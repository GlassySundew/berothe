package ui.core;

import util.Assets;
import h2d.col.Bounds;
import dn.heaps.filter.PixelOutline;
import h2d.Drawable;
import h2d.Font;
import h2d.Object;

class ShadowedText extends h2d.Text {

	public function new( ?font : Font, ?parent : h2d.Object ) {
		super( font == null ? Assets.fontPixel16 : font, parent );

		smooth = false;
		addTextOutlineTo( this );
	}

	public static function addTextOutlineTo( drawable : Drawable ) {
		var outline = new PixelOutline( 0x000000, 10 );
		drawable.filter = outline;
	}
}
