package ui.domkit.element;

import h2d.RenderContext;
import h2d.col.Bounds;
import ui.core.TextInput;
import util.Assets;
import h2d.Font;
import h2d.domkit.Object;

@:uiComp( "text-input" )
class TextInputComp extends TextInput implements h2d.domkit.Object {

	@:p public var backgroundColorProp( default, set ) : Int;
	function set_backgroundColorProp( v : Int ) {
		return backgroundColorProp = backgroundColor = v;
	}

	@:p public var inputWidthProp( default, set ) : Int;
	function set_inputWidthProp( v : Int ) {
		this.textWidth = v;
		return inputWidth = v;
	}

	var contentChangedTriggered = false;

	public function new( ?font : Font, ?parent ) {
		super( font == null ? Assets.fontPixel : font, parent );
		initComponent();
	}

	override function sync( ctx : RenderContext ) {
		if ( !contentChangedTriggered ) {
			contentChangedTriggered = true;
			onContentChanged();
		}
		super.sync( ctx );
	}
}
