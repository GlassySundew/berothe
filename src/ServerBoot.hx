/**
	entrypoint for headless standalone server executable
**/

import sys.thread.Thread;
import util.Repeater;
import hxd.System;
import hxd.Timer;
import net.Server;

/** server-side **/
class ServerBoot {

	public static var inst( default, null ) : ServerBoot;
	public static var server : Server;

	static public function main() : Void {
		inst = new ServerBoot();
	}

	var fps = 0.;
	var speed = 1.0;

	var lastTime : Float = Sys.time();

	final oneSlashSixty = 1 / 60;

	function mainLoop() {
		hxd.Timer.update();

		var currentTime : Float = Sys.time();
		var dt : Float = currentTime - lastTime;
		fps = 1.0 / dt;
		var delaySeconds = oneSlashSixty - dt;

		lastTime = currentTime;

		if ( delaySeconds > 0 ) {
			Sys.sleep( delaySeconds );
		}

		var tmod = hxd.Timer.tmod * speed;
		dn.Process.updateAll( tmod );
	}

	public function new() {

		haxe.Log.trace = function ( v : Dynamic, ?infos : haxe.PosInfos ) {
			var str = haxe.Log.formatOutput( "\n\t\033[38;5;162m" + v, infos );
			Sys.println( "[SERVER] " + str + "\033[0m" );
		}

		hxd.System.start( function () {
			mainLoop();
			hxd.System.setLoop( mainLoop );

			server = new Server();

			#if !debug
			hl.UI.closeConsole();
			#end
		} );

		// Repeater.repeatSeconds(() -> trace( fps, Timer.dt ), 5 );
	}
}
