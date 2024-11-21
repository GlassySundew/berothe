package ui.domkit.element;

import hxd.Event;
import h2d.Flow;
import dn.heaps.slib.HSprite;
import ui.core.Button;
import util.Assets;

@:uiComp( "button" )
class ButtonComp extends Flow implements h2d.domkit.Object {

	public var onClick( never, set ) : Event -> Void;
	inline function set_onClick( v : Event -> Void ) return button.onClick = v;

	final button : Button;

	public function new( key : String, keyAmount : Int, ?parent : h2d.Object ) {
		var tiles = [for ( i in 0...keyAmount ) {
			new HSprite( Assets.ui, key + i ).tile;
		}];

		super( parent );

		button = new Button( tiles, this );

		initComponent();
	}
}
