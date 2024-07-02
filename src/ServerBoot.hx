/**
	entrypoint for headless standalone server executable
**/

import hxd.Timer;
import net.Server;

/** server-side **/
class ServerBoot {

	public static var inst( default, null ) : ServerBoot;
	public static var server : Server;

	static public function main() : Void {
		inst = new ServerBoot();
	}

	function loadAssets( onLoaded : Void -> Void ) {
		onLoaded();
	}

	var speed = 1.0;
	final thousandSlashSixty = 1000 / 60;

	function mainLoop() {
		Sys.sleep(( thousandSlashSixty - Timer.dt ) / 1000 );
		hxd.Timer.update();
		var dt = hxd.Timer.dt;

		var tmod = hxd.Timer.tmod * speed;
		dn.Process.updateAll( tmod );
	}

	function update( dt : Float ) {}

	public function new() {

		haxe.Log.trace = function ( v : Dynamic, ?infos : haxe.PosInfos ) {
			var str = haxe.Log.formatOutput( "\033[34m" + v, infos );
			Sys.println( "[SERVER] " + str + "\033[0m" );
		}

		hxd.System.start( function () {
			loadAssets( function () {
				hxd.Timer.skip();
				mainLoop();
				hxd.System.setLoop( mainLoop );

				server = new Server();
			} );
		} );
	}
}
