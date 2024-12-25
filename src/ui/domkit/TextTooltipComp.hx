package ui.domkit;

import h3d.Vector4;
import util.Assets;
import h2d.Font;
import h2d.Object;
import h2d.RenderContext;
import h2d.domkit.Style;
import h2d.filter.Shader;
import shader.CornersRounder;
import ui.domkit.element.ShadowedTextComp;

@:uiComp( "textTooltip" )
class TextTooltipComp extends h2d.Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC =
		<textTooltip id="labelThis">
			// <shadowed-text(text, font) public id="shadowed_text" />
			<shadowed-text(text, font) text='$text' public id="shadowed_text" />
		</textTooltip>;

	// @formatter:on
	public var font( get, set ) : Font;
	inline function get_font() return shadowed_text.font;
	inline function set_font( s ) return shadowed_text.font = s;

	public var label( get, set ) : String;
	inline function get_label() return shadowed_text.text;
	inline function set_label( s ) return shadowed_text.text = s;

	public var color( get, set ) : Vector4;
	inline function get_color() return shadowed_text.color;
	inline function set_color( s ) return shadowed_text.color = s;

	public var cornersRounder : CornersRounder;

	public function new( text : String = "", ?font : Font, ?style : Style, ?parent : Object ) {
		super( parent );
		initComponent();
		font = font == null ? Assets.fontPixel16 : font;
		this.font = font;
		label = text;

		style = style == null ? new h2d.domkit.Style() : style;
		style.load( hxd.Res.domkit.textTooltip );
		style.addObject( this );

		cornersRounder = new CornersRounder();
		filter = new Shader( cornersRounder );
	}
}
