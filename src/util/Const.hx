package util;

import oimo.common.Vec3;
import dn.M;

class Const {

	public static final APPNAME = "Berothe";

	public static final FOURTY_FIVE_DEGREE_RAD = M.toRad( 45 );

	public static var FPS = 60;
	public static var AUTO_SCALE_TARGET_WID = -1; // -1 to disable auto-scaling on width
	public static var AUTO_SCALE_TARGET_HEI = -1; // -1 to disable auto-scaling on height
	public static var SCALE = 10;
	public static var UI_SCALE( get, never ) : Float;
	static function get_UI_SCALE() : Float {
		return #if client Boot.inst.s2d.viewportScaleX #else 1. #end;
	}

	static var inc = 0;

	public static var DP_BG = inc++;
	public static var DP_FX_BG = inc++;
	public static var DP_MAIN = inc++;
	public static var DP_TOP = inc++;
	public static var DP_FX_TOP = inc++;

	public static var DP_UI_NICKNAMES = inc++;
	public static var DP_UI = inc++;
	public static var DP_UI_FRONT = inc++;
	public static var DP_MASK = inc++;
	public static var DP_IMGUI = inc++;

	public static var LEVELS_PATH = "levels/";
	public static var ATLAS_PATH = "tiled/atlas/";
	public static var SAVEFILE_EXT = ".zhopa";

	public static final worldGravity = new Vec3( 0, 0, -9.8 );

	public static var chunkVisionRadius = 4;

	// physics
	public static final G_PHYSICS : Int = 1;
	public static final G_HITBOX : Int = 2;
	public static final G_TEST : Int = 4;

	public static final cdbTypeIdent : String = "$cdbtype";
}
