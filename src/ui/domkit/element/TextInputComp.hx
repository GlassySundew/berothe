package ui.domkit.element;

import h2d.Flow;
import h2d.RenderContext;
import h2d.col.Bounds;
import ui.core.TextInput;
import util.Assets;
import h2d.Font;
import h2d.domkit.Object;

@:uiComp( "text-input" )
class TextInputComp extends Flow implements h2d.domkit.Object {

	@:p public var backgroundColorProp( default, set ) : Int;
	function set_backgroundColorProp( v : Int ) {
		return backgroundColorProp = textInput.backgroundColor = v;
	}

	public var text( get, set ) : String;
	inline function get_text() return textInput.text;
	inline function set_text( v : String ) return textInput.text = v;

	var contentChangedTriggered = false;
	final textInput : TextInput;

	public function new( ?font : Font, ?parent ) {
		super( parent );
		textInput = new TextInput( font == null ? Assets.fontPixel16 : font, this );
		initComponent();
	}

	override function sync( ctx : RenderContext ) {
		if ( !contentChangedTriggered ) {
			contentChangedTriggered = true;
			onContentChanged();
		}
		super.sync( ctx );
		textInput.inputWidth = this.outerWidth;
	}
}
