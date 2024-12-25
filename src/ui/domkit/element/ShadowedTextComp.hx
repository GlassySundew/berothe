package ui.domkit.element;

import h3d.Vector4;
import h2d.Flow;
import ui.core.ShadowedText;
import h2d.Font;
import h2d.Object;

@:uiComp( "shadowed-text" )
class ShadowedTextComp extends Flow implements h2d.domkit.Object {

	public var text( get, set ) : String;
	inline function get_text() return textLabel.text;
	inline function set_text( v : String ) return textLabel.text = v;

	public var font( get, set ) : Font;
	inline function get_font() return textLabel.font;
	inline function set_font( v : Font ) return textLabel.font = v;

	public var color( get, set ) : Vector4;
	inline function get_color() return textLabel.color;
	inline function set_color( v : Vector4 ) return textLabel.color = v;

	public final textLabel : ShadowedText;

	public function new( ?text : String = "", ?font : Font, ?parent : h2d.Object ) {
		super( parent );
		textLabel = new ShadowedText( this );
		initComponent();

		this.text = text;
	}
}
