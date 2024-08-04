#if client
import game.data.storage.DataStorage;
import signals.*;
import core.MutableProperty;
import dn.Process;
import dn.heaps.input.Controller;
import dn.heaps.input.ControllerAccess;
import game.client.ControllerAction;
import game.net.client.GameClient;
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
import util.Repeater;
import util.Settings;
import util.tools.Save;

/**
	client-side only
**/
@:publicFields
class Main extends Process {

	public static var inst : Main;

	public var console : ui.Console;
	public var controller : Controller<ControllerAction>;
	public var ca : ControllerAccess<ControllerAction>;
	public var save : Save;
	public var cliCon : MutableProperty<ClientController> = new MutableProperty( null );

	public var onClose : Signal = new Signal();
	public var onResizeEvent : Signal = new Signal();
	public var onUpdate : Signal = new Signal();

	#if game_tmod
	var stats : h2d.Text;
	#end

	public function new( s : h2d.Scene ) {
		super();
		inst = this;
		createRoot( s );

		setupResources();
		setupRenderer();

		Assets.init();
		Cursors.init();
		Lang.init( "en" );

		Data.load( hxd.Res.data.entry.getText() );
		new DataStorage();

		createUi();

		initGamePadController();

		Settings.inst.loadSettings();

		onClose.add(() -> {
			Settings.inst.saveSettings();
		} );

		hxd.Window.getInstance().onClose = function () {
			onClose.dispatch();
			return true;
		}

		new Client();
		MainMenu.spawn( Boot.inst.s2d );

		#if debug
		Boot.inst.createServer();
		Engine.getCurrent().backgroundColor = 0xff393939;
		#end

		var dir = new h3d.scene.fwd.DirLight( new h3d.Vector( -0.3, -0.2, -1 ), Boot.inst.s3d );
		dir.color.set( 0.5, 0.5, 0.5 );
	}

	function createUi() {
		console = new ui.Console( Assets.fontPixel, Boot.inst.s2d );

		#if debug
		createFpsCounter();
		#if game_tmod
		stats = new Text( Assets.fontPixel, Boot.inst.s2d );
		#end
		#end
	}

	function createFpsCounter() {
		var fps = new Text( Assets.fontPixel, Boot.inst.s2d );

		onUpdate.add(() -> @:privateAccess {
			fps.text = '${Boot.inst.engine.fps}\ndraw calls: ${Boot.inst.engine.drawCalls}';
		} );
	}

	function setupResources() {
		#if( hl && pak )
		hxd.Res.initPak();
		#elseif( hl )
		hxd.res.Resource.LIVE_UPDATE = true;
		hxd.Res.initLocal();
		#end

		#if debug
		hxd.Res.data.watch( function () {
			Data.load( hxd.Res.data.entry.getBytes().toString() );
			// if ( GameServer.inst != null ) GameServer.inst.onCdbReload();
		} );
		#end
	}

	function setupRenderer() {
		var renderer = new CustomRenderer();
		renderer.depthColorMap = hxd.Res.gradients.test.toTexture();
		Std.downcast( Boot.inst.s3d.lightSystem, h3d.scene.fwd.LightSystem ).ambientLight.set( .5, .5, .5 );

		Boot.inst.s3d.renderer = Boot.inst.renderer = renderer;
	}

	function initGamePadController() {
		controller = Controller.createFromAbstractEnum( ControllerAction );
		ca = controller.createAccess();
		// ca.lockCondition
		controller.bindKeyboard( MoveUp, [Key.UP, Key.W] );
		controller.bindKeyboard( MoveLeft, [Key.LEFT, Key.A] );
		controller.bindKeyboard( MoveDown, [Key.DOWN, Key.S] );
		controller.bindKeyboard( MoveRight, [Key.RIGHT, Key.D] );

		controller.bindPadLStick4( MoveLeft, MoveRight, MoveUp, MoveDown );

		controller.bindKeyboard( Action, Key.E );
		controller.bindKeyboard( DropItem, Key.Q );
		controller.bindKeyboard( ToggleInventory, Key.TAB );
		controller.bindKeyboard( ToggleCraftingMenu, Key.C );
		controller.bindKeyboard( Attack, Key.F );

		controller.bindKeyboard( Escape, Key.ESCAPE );
	}

	public function toggleFullscreen() {
		#if hl
		var s = hxd.Window.getInstance();
		s.displayMode = s.displayMode == Fullscreen ? Windowed : Fullscreen;
		Settings.inst.params.fullscreen = s.displayMode == Fullscreen;
		#end
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

		root.setScale( Const.UI_SCALE );

		onResizeEvent.dispatch();
	}

	override function update() {
		// dn.heaps.slib.SpriteLib.TMOD = tmod;
		if ( ca.isKeyboardPressed( Key.F11 ) ) toggleFullscreen();
		// if ( ca.isKeyboardPressed(Key.M) ) Assets.toggleMusicPause();

		#if game_tmod
		stats.text = "tmod: " + tmod;
		#end

		onUpdate.dispatch();
		super.update();
	}
}
#end
