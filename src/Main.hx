import ui.core.ShadowedText;
import h2d.Flow;
import ui.CustomFlow;
import hxd.Event;
import sdl.Window;
import hrt.prefab.rfx.Sao;
import hrt.prefab.Object3D;
import h3d.scene.pbr.DirLight;
import rx.disposables.Assignable;
import rx.disposables.Boolean;
import rx.Subscription;
import rx.Observable;
import rx.observables.Create;
import rx.subjects.Behavior;
import rx.ObservableFactory;
import signals.Signal;
#if client
import core.MutableProperty;
import dn.Process;
import dn.heaps.input.Controller;
import dn.heaps.input.ControllerAccess;
import game.client.ControllerAction;
import game.data.storage.DataStorage;
import h2d.Text;
import h3d.Engine;
import hxd.Key;
import net.Client;
import net.ClientController;
import pass.CustomRenderer;
import ui.MainMenu;
import util.Assets;
import util.Const;
import util.Cursors;
import util.Lang;
import util.Settings;
import util.tools.Save;

/**
	client-side only
**/
@:publicFields
class Main extends Process {

	public static var inst : Main;

	public var console( default, null ) : ui.Console;
	public var escapeController( default, null ) : Controller<EscapeAction>;
	public var controller( default, null ) : Controller<ControllerAction>;
	public var ca( default, null ) : ControllerAccess<ControllerAction>;
	public var save( default, null ) : Save;
	public var cliCon( default, null ) : MutableProperty<ClientController> = new MutableProperty( null );

	public var botRightHud : Flow;
	public var botLeftHud : Flow;
	public var topRightHud : Flow;
	public var hudLayout( default, null ) : CustomFlow;

	public final onClose : Signal = new Signal();
	public final onResizeEvent : Signal = new Signal();
	public final onUpdate : Signal = new Signal();

	#if game_tmod
	var stats : h2d.Text;
	#end

	var attackPadBind : PadButton;

	public function new( s : h2d.Scene ) {
		super();
		inst = this;
		createRoot( s );

		setupRenderer();

		Assets.init();
		Cursors.init();
		Lang.init( "en" );

		Data.load( hxd.Res.data.entry.getText() );
		new DataStorage();

		initGamePadController();

		createUi();

		Settings.inst.loadSettings();

		onClose.add(() -> {
			Settings.inst.saveSettings();
		} );

		hxd.Window.getInstance().onClose = function () {
			onClose.dispatch();
			return true;
		}

		new Client();
		root.add( new MainMenu().rootCtx, Const.DP_MAIN );

		#if debug
		Boot.inst.createServer();
		#end
	}

	function createUi() {
		console = new ui.Console( Assets.fontPixel16 );

		root.add( console, Const.DP_UI_FRONT );

		hudLayout = new CustomFlowComponent();
		hudLayout.customFillHeight = true;
		hudLayout.customFillWidth = true;

		botRightHud = new CustomFlowComponent( hudLayout );
		hudLayout.getProperties( botRightHud ).isAbsolute = true;
		hudLayout.getProperties( botRightHud ).align( Bottom, Right );

		botLeftHud = new CustomFlowComponent( hudLayout );
		botLeftHud.layout = Vertical;
		hudLayout.horizontalAlign = Left;
		hudLayout.getProperties( botLeftHud ).isAbsolute = true;
		hudLayout.getProperties( botLeftHud ).align( Bottom, Left );

		topRightHud = new CustomFlowComponent( hudLayout );
		topRightHud.layout = Vertical;
		topRightHud.horizontalAlign = Right;
		hudLayout.getProperties( topRightHud ).isAbsolute = true;
		hudLayout.getProperties( topRightHud ).align( Top, Right );

		root.add( hudLayout, Const.DP_UI );

		Assets.bindStyle( Assets.styleCommon, hudLayout );
		
		#if debug
		createFpsCounter();
		#if game_tmod
		stats = new Text( Assets.fontPixel16, Boot.inst.s2d );
		#end
		#end
	}

	function createFpsCounter() {
		var fps = new ShadowedText( Assets.fontPixel16 );

		topRightHud.addChild( fps );

		onUpdate.add(() -> @:privateAccess {
			fps.text = 'fps: ${Boot.inst.engine.fps}\ndraw calls: ${Boot.inst.engine.drawCalls}';
		} );
	}

	function setupRenderer() {

		// var light = new DirLight( new h3d.Vector( -0.4, -0.1, -1 ), Boot.inst.s3d );
		// light.power = 0.4;
	}

	function initGamePadController() {
		controller = Controller.createFromAbstractEnum( ControllerAction );
		escapeController = Controller.createFromAbstractEnum( EscapeAction );

		ca = controller.createAccess();
		// ca.lockCondition
		controller.bindKeyboard( MOVE_UP, [Key.UP, Key.W] );
		controller.bindKeyboard( MOVE_LEFT, [Key.LEFT, Key.A] );
		controller.bindKeyboard( MOVE_DOWN, [Key.DOWN, Key.S] );
		controller.bindKeyboard( MOVE_RIGHT, [Key.RIGHT, Key.D] );

		controller.bindPadLStick4( MOVE_LEFT, MOVE_RIGHT, MOVE_UP, MOVE_DOWN );

		controller.bindKeyboard( ACTION, Key.E );
		controller.bindKeyboard( DROP_ITEM, Key.Q );
		controller.bindKeyboard( TOGGLE_INVENTORY, Key.TAB );
		controller.bindKeyboard( ATTACK, Key.F );

		escapeController.bindKeyboard( ESCAPE, Key.ESCAPE );

		controller.bindPad( ATTACK, X );

		Boot.inst.s3d.addEventListener( onSceneEvent );

		// saving confinured attack pad code for emulation with mouse click
		@:privateAccess
		for ( binding in controller.bindings[ATTACK] ) {
			if ( binding.padButton != null ) {
				attackPadBind = binding.padButton;
				break;
			}
		}
	}

	public function toggleFullscreen() {
		#if hl
		var s = hxd.Window.getInstance();
		s.displayMode = s.displayMode == Fullscreen ? Windowed : Fullscreen;
		Settings.inst.params.fullscreen = s.displayMode == Fullscreen;
		#end
	}

	function onSceneEvent( e : Event ) {
		setAttackToggle( Key.isDown( Key.MOUSE_LEFT ) );
	}

	#if !debug inline #end
	function setAttackToggle( value : Bool ) {
		@:privateAccess
		controller.pad._setButton( controller.getPadButtonId( attackPadBind ), value );
	}

	override function onDispose() {
		#if game_tmod
		if ( stats != null ) stats.remove();
		#end
	}

	override function onResize() {
		super.onResize();

		// if ( Const.AUTO_SCALE_TARGET_WID > 0 )
		// 	Const.UI_SCALE = M.ceil(h() / Const.AUTO_SCALE_TARGET_WID);
		// else if ( Const.AUTO_SCALE_TARGET_HEI > 0 )
		// 	Const.UI_SCALE = M.floor(h() / Const.AUTO_SCALE_TARGET_HEI);

		// root.setScale( Const.UI_SCALE );

		// Boot.inst.s2d.scaleX = Boot.inst.s2d.scaleY = 2;
		Boot.inst.s2d.scaleMode = AutoZoom( 800, 400, true );

		var win = hxd.Window.getInstance();
		@:privateAccess {
			Boot.inst.s2d.width = win.width;
			Boot.inst.s2d.height = win.height;
		}

		onResizeEvent.dispatch();
	}

	override function update() {
		// dn.heaps.slib.SpriteLib.TMOD = tmod;
		if ( ca.isKeyboardPressed( Key.F11 ) ) toggleFullscreen();
		if ( ca.isKeyboardPressed( Key.ENTER ) )
			console.show();

		#if game_tmod
		stats.text = "tmod: " + tmod;
		#end

		onUpdate.dispatch();
		super.update();

		Assets.update( dt );
	}
}
#end
