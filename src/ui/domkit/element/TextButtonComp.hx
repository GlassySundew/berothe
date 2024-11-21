package ui.domkit.element;

import h2d.Flow;
import ui.core.TextButton;
import hxd.Event;
import h2d.domkit.Object;

@:uiComp( "text-button" )
class TextButtonComp extends Flow implements Object {

	public var onClick( never, set ) : Event -> Void;
	inline function set_onClick( v : Event -> Void ) return button.onClick = v;

	final button : TextButton;

	public function new(
		title : String,
		?action : Event -> Void,
		?colorDef : Int = 0xffffffff,
		?colorPressed : Int = 0xFF676767,
		?prefix : String = "> ",
		?parent : h2d.Object
	) {
		super( parent );
		button = new TextButton( title, prefix, action, colorDef, colorPressed, this );
		initComponent();
	}
}
