package util;

import dn.heaps.assets.Atlas;
import dn.heaps.slib.*;
import hxd.Res;
import util.Const;
import util.tilesets.Tileset;

class Assets {

	// public static var SFX = dn.heaps.Sfx.importDirectory("sfx");
	public static var fontPixel : h2d.Font;

	// public static var fontTiny:h2d.Font;
	// public static var fontSmall:h2d.Font;
	// public static var fontMedium:h2d.Font;
	// public static var fontLarge:h2d.Font;
	public static var player : SpriteLib;
	public static var items : SpriteLib;
	public static var structures : SpriteLib;
	public static var ui : SpriteLib;
	public static var env : SpriteLib;

	public static var modelCache = new util.threeD.ModelCache();

	public static var CONGRUENT : Tileset;

	static var music : dn.heaps.Sfx;

	public static function init() {

		fontPixel = hxd.Res.fonts.Haversham_new.toFont(); // toSdfFont(16, MultiChannel, 1, 1 / 16);

		// fontPixel.resizeTo(fontPixel.size >>1);
		// fontPixel
		// fontPixel.resizeTo(8);

		// fontTiny = hxd.Res.fonts.barlow_condensed_medium_regular_9.toFont();
		// fontSmall = hxd.Res.fonts.barlow_condensed_medium_regular_11.toFont();
		// fontMedium = hxd.Res.fonts.barlow_condensed_medium_regular_17.toFont();
		// fontLarge = hxd.Res.fonts.barlow_cxntondensed_medium_regular_32.toFont();

		items = Atlas.load( Const.ATLAS_PATH + "items.atlas" );
		ui = Atlas.load( Const.ATLAS_PATH + "ui.atlas" );

		ui.defineAnim( "keyboard_icon", "0-1" );
	}

	public static function playMusic() {
		// trace("Playing music");
		// music.play(true);
	}

	public static function toggleMusicPause() {
		// music.togglePlay(true);
	}
}
