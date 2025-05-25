package ui.dialog;

import signals.Signal;
import ui.core.Button;
import util.Assets;
import dn.heaps.slib.HSprite;
import util.GameUtil;
import util.Util;
import util.Const;
import dn.heaps.input.ControllerAccess;
import dn.Process;
import game.client.ControllerAction;
import h2d.Flow;
import h2d.Object;
import h2d.Tile;
import ui.core.OnSceneAddedObject;

class PopupBase extends Process {

	static var popups : Array<PopupBase> = [];

	public static function destroyByPopupType( popupCl : Class<PopupBase> ) {
		getPopupByClass( popupCl ).destroy();
	}

	public static function getPopupByClass<T : PopupBase>( popupCl : Class<T> ) : T {
		return cast popups.filter( m -> return Type.getClass( m ) == cast popupCl )[0];
	}

	var escapeCa : ControllerAccess<EscapeAction>;

	final contentFlow : Flow;
	final onResizeSignal = new Signal();

	var overlayFlow : Flow;
	var centrized = false;
	var contentTopPadding( get, never ) : Int;
	var escapableByKey = true;

	function get_contentTopPadding() : Int
		return 0;

	public final rootCtx : Object;

	public function new( ?parent : Object, ?parentProcess : Process ) {
		super( parentProcess );
		popups.push( this );

		rootCtx = parent == null ? new Object() : parent;
		
		createRoot( rootCtx );

		contentFlow = new Flow( root );
		contentFlow.verticalSpacing = 5;
		contentFlow.verticalAlign = Middle;

		escapeCa = ClientMain.inst.escapeController.createAccess();
		escapeCa.takeExclusivity();
		escapeCa.lock( 0.1 );

		onResizeCb = onResizeSignal.dispatch;
	}

	function centrizeContent( ?paddingLeft = 80 ) {
		centrized = true;

		contentFlow.paddingLeft = paddingLeft;
		contentFlow.layout = Vertical;
	}

	override function update() {
		super.update();

		if (
			escapableByKey
			&& escapeCa.isPressed( ESCAPE ) //
		) {
			destroy();
		}
	}

	function backgroundOnClick( e ) {}

	override function onDispose() {
		super.onDispose();

		escapeCa.releaseExclusivity();
		escapeCa.dispose();

		popups.remove( this );

		if ( popups.length > 0 ) {
			popups[popups.length - 1].escapeCa.takeExclusivity();
			popups[popups.length - 1].onFocus();
		}
	}

	function onFocus() {}

	override function onResize() {
		super.onResize();

		if ( overlayFlow != null ) {
			overlayFlow.minHeight = GameUtil.hScaled + 1;
			overlayFlow.minWidth = GameUtil.wScaled;
		}

		if ( centrized ) {
			contentFlow.minHeight = contentFlow.maxHeight = GameUtil.hScaled;
			contentFlow.minWidth = contentFlow.maxWidth = GameUtil.wScaled;
			contentFlow.paddingTop = contentTopPadding;
		}
	}

	function createBg() {
		overlayFlow = new Flow();
		root.addChildAt( overlayFlow, Const.DP_BG );
		overlayFlow.backgroundTile = Tile.fromColor( 0x000000, 1, 1, 0.75 );
		overlayFlow.enableInteractive = true;
		overlayFlow.interactive.onClick = backgroundOnClick;
	}

	function createCloseButton() {
		var flow = new Flow( contentFlow );
		onResizeSignal.add(() -> {
			flow.minHeight = GameUtil.hScaled;
			flow.minWidth = GameUtil.wScaled;
		} );
		onResizeSignal.fireOnAdd();

		var close0 = new HSprite( Assets.ui, "close_but_0" );
		var close1 = new HSprite( Assets.ui, "close_but_1" );
		var startButton = new Button( [close0.tile, close1.tile, close0.tile], flow );
		var flowProps = flow.getProperties( startButton );
		flowProps.align( Top, Right );
		flowProps.paddingTop = flowProps.paddingRight = 30;
		contentFlow.getProperties( flow ).isAbsolute = true;
		startButton.onClickEvent.add( ( e ) -> destroy() );
	}
}
