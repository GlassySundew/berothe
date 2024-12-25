package util;

import dn.heaps.assets.Aseprite;
import dn.heaps.assets.Atlas;
import dn.heaps.slib.*;
import hxd.Res;
import util.Const;
import util.tilesets.Tileset;

class Assets {

	// public static var SFX = dn.heaps.Sfx.importDirectory("sfx");
	public static var fontPixel16 : h2d.Font;
	public static var fontPixel32 : h2d.Font;

	// public static var fontTiny:h2d.Font;
	// public static var fontSmall:h2d.Font;
	// public static var fontMedium:h2d.Font;
	// public static var fontLarge:h2d.Font;
	public static var player : SpriteLib;
	public static var items : SpriteLib;
	public static var structures : SpriteLib;

	public static var uiAseDict = Aseprite.getDict( Res.tiled.ase.ui );
	public static var uiAse : aseprite.Aseprite;
	public static var ui : SpriteLib;

	public static var env : SpriteLib;

	public static var modelCache = new util.threeD.ModelCache();

	public static var CONGRUENT : Tileset;

	public static var healthBarStat : StatAsset;

	static var music : dn.heaps.Sfx;

	public static function init() {

		fontPixel16 = hxd.Res.fonts.lookout.toSdfFont( 16, Alpha, 0.5, 0.0 );
		// fontPixel16 = hxd.Res.fonts.Haversham_fnt.toFont();
		// fontPixel16.resizeTo( 16 );

		fontPixel32 = fontPixel16.clone();
		fontPixel32.resizeTo( 32 );

		// fontPixel.resizeTo(fontPixel.size >>1);
		// fontPixel
		// fontPixel.resizeTo(8);

		// fontTiny = hxd.Res.fonts.barlow_condensed_medium_regular_9.toFont();
		// fontSmall = hxd.Res.fonts.barlow_condensed_medium_regular_11.toFont();
		// fontMedium = hxd.Res.fonts.barlow_condensed_medium_regular_17.toFont();
		// fontLarge = hxd.Res.fonts.barlow_cxntondensed_medium_regular_32.toFont();

		items = Atlas.load( Const.ATLAS_PATH + "items.atlas" );

		uiAse = Res.tiled.ase.ui.toAseprite();
		ui = Aseprite.convertToSLib( 30, uiAse );

		ui.defineAnim( "keyboard_icon", "0-1" );

		healthBarStat = new StatAsset( uiAseDict.health_bg, uiAseDict.health_stat );
	}

	public static function playMusic() {
		// trace("Playing music");
		// music.play(true);
	}

	public static function toggleMusicPause() {
		// music.togglePlay(true);
	}
}
