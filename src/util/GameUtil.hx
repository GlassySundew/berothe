package util;

import hxbit.NetworkHost.NetworkClient;

class GameUtil {

	public static var s3dWScaled( get, never ) : Int;
	inline static function get_s3dWScaled()
		return Std.int( Boot.inst.s2d.width / Const.SCALE );

	public static var s3dHScaled( get, never ) : Int;
	inline static function get_s3dHScaled()
		return Std.int( Boot.inst.s2d.height / Const.SCALE );

	public static var wScaled( get, never ) : Int;
	inline static function get_wScaled()
		return Std.int( Boot.inst.s2d.width / Const.UI_SCALE );

	public static var hScaled( get, never ) : Int;
	inline static function get_hScaled()
		return Std.int( Boot.inst.s2d.height / Const.UI_SCALE );

	public static var mouseXScaled( get, never ) : Int;
	inline static function get_mouseXScaled()
		return Std.int( Boot.inst.s2d.mouseX / Const.UI_SCALE );

	public static var mouseYScaled( get, never ) : Int;
	inline static function get_mouseYScaled()
		return Std.int( Boot.inst.s2d.mouseY / Const.UI_SCALE );


	public static function sendTypedMessage(
		sHost : hxd.net.SocketHost,
		msg : net.Message,
		?to : NetworkClient
	) sHost.sendMessage( msg, to );

	public static dynamic function onTypedMessage( sHost : hxd.net.SocketHost, onMessage : NetworkClient -> net.Message -> Void ) {
		sHost.onMessage = onMessage;
	}
}
