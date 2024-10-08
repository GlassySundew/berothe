package ui.domkit;

import dn.M;
import ui.core.Button;
import ui.core.Dragable;
import util.Assets;
import signals.Signal2;
import signals.Signal;
import hxd.Event;
import en.player.Player;
import h2d.domkit.Style;
import h2d.RenderContext;
import h2d.ScaleGrid;
import h2d.Flow;
import dn.heaps.slib.HSprite;

interface WindowCompI {
	public var window : WindowComp;
}

/**background nineslice**/
@:uiComp( "window" )
class WindowComp extends Flow implements h2d.domkit.Object implements WindowCompI {

	public var window : WindowComp;
	public var style : Style;
	public var bringOnTopOfALL : Void -> Void;
	public var clampInScreen : Void -> Void;

	/** dragable callbacks **/
	public var onDrag : Signal2<Float, Float> = new Signal2();
	public var onPush : Event -> Void;
	public var onRelease : Event -> Void;
	public var toggleVisible : Void -> Void;

	static var SRC = <window class="window_root" layout="vertical">
			<flow class="dragable_comp" public id="dragable_comp" />
			<flow class="close_button" public id="close_button" />
			<textTooltip("window", null, style) class="windowLabel" public id="windowLabel" />
		</window>;

	public function new( tile : h2d.Tile, bl : Int, bt : Int, br : Int, bb : Int, parent : Null<h2d.Object> ) {
		super( parent );

		style = new h2d.domkit.Style();

		initComponent();

		window = this;

		borderLeft = bl;
		borderTop = bt;
		borderRight = br;
		borderBottom = bb;

		backgroundTile = tile;

		style.load( hxd.Res.domkit.window );
		style.addObject( this );
	}

	override function sync( ctx : RenderContext ) {
		super.sync( ctx );
		dragable_comp.minWidth = window.innerWidth;
	}

	public function makeDragable() {
		var dragable = new Dragable( 0, 0,
			onDrag.dispatch,
			onPush,
			round,
			true, true );
		dragable_comp.addChild( dragable );
		dragable_comp.getProperties( dragable ).isAbsolute = true;
	}

	inline function round( ?v ) {
		x = M.round( x );
		y = M.round( y );
	}

	public function makeCloseButton( ?atlasName : String = "close_button_inventory" ) {
		var close_button_inventory0 = new HSprite( Assets.ui, '${atlasName}0' );
		var close_button_inventory1 = new HSprite( Assets.ui, '${atlasName}1' );
		var close_button_inventory2 = new HSprite( Assets.ui, '${atlasName}2' );

		var closeButton = new Button( [
			close_button_inventory0.tile,
			close_button_inventory1.tile,
			close_button_inventory2.tile
		] );
		closeButton.propagateEvents = true;

		closeButton.onClickEvent.add( ( _ ) -> {
			toggleVisible();
		} );

		close_button.addChild( closeButton );
	}
}
