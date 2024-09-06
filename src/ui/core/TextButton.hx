package ui.core;

import h2d.Flow;
import h2d.Font;
import h3d.Vector4;
import dn.legacy.Color;
import hxd.Res;
import util.Assets;
import h3d.mat.Texture;
import hxd.Event;

class TextButton extends Button {

	var texDefault : Texture;
	var texPrefix : Texture;
	var texPrefixPressed : Texture;
	var colorDefault : Int;
	var colorPressed : Int;
	var title : String;
	var font : Font;
	var prefix : String;

	public function new(
		title : String,
		prefix = "> ",
		?font : Font,
		?action : Event -> Void,
		?colorDefault : Int = 0xffffffff,
		?colorPressed : Int = 0xFF8A8A8A,
		?parent
	) {
		this.font = font ?? Assets.fontPixel16;
		this.colorDefault = colorDefault;
		this.colorPressed = colorPressed;
		this.title = title;
		this.prefix = prefix;

		refresh();

		super(
			[
				h2d.Tile.fromTexture( texDefault ),
				h2d.Tile.fromTexture( texPrefix ),
				h2d.Tile.fromTexture( texPrefixPressed )
			],
			parent
		);
		onClickEvent.add( action != null ? action : ( _ ) -> {} );
		onClickEvent.add( ( e ) -> Res.sfx.click.play( 0.25 ) );
	}

	function refresh() {
		var flow = new Flow();
		var prefixText = new ShadowedText( font );
		prefixText.color = Vector4.fromColor( colorDefault );
		prefixText.text = prefix;
		flow.addChild( prefixText );

		var text = new ShadowedText( font );
		text.color = Vector4.fromColor( colorDefault );
		text.text = title;
		flow.addChild( text );

		flow.paddingBottom = flow.paddingTop = ( font.size >> 2 ) + 1;

		var wid = Std.int( flow.outerWidth );
		var hei = Std.int( flow.outerHeight );
		texDefault = new Texture( wid, hei, [Target] );
		texPrefix = new Texture( wid, hei, [Target] );
		texPrefixPressed = new Texture( wid, hei, [Target] );

		prefixText.visible = false;
		flow.drawTo( texDefault );

		prefixText.visible = true;
		flow.drawTo( texPrefix );

		text.color = Vector4.fromColor( colorPressed );
		prefixText.color = Vector4.fromColor( colorPressed );
		flow.drawTo( texPrefixPressed );

		states = [
			h2d.Tile.fromTexture( texDefault ),
			h2d.Tile.fromTexture( texPrefix ),
			h2d.Tile.fromTexture( texPrefixPressed )
		];
		processStates( states );

		width = states[0].width;
		height = states[0].height;
	}
}
