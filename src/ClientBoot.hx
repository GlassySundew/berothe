import echoes.Entity;
import echoes.System;
import echoes.World;
import graphics.ObjectNode3D;
#if client
import h2d.Scene;
import pass.CustomRenderer;
import signals.Signal;
import util.Env;
import util.Util;
import util.tools.Save;

class ClientBoot extends hxd.App {

	public static var inst( default, null ) : ClientBoot;

	public var renderer : CustomRenderer;
	public var deltaTime( default, null ) : Float;

	public var onResizeSignal : Signal = new Signal();

	static function main() {
		new ClientBoot();
	}

	public function new() {
		inst = this;
		super();
	}

	// Engine ready
	override function init() {
		Env.init();
		Save.initFields();

		haxe.Log.trace = function ( v : Dynamic, ?infos : haxe.PosInfos ) {
			#if hx_concurrent
			var str = formatOutput( v, infos );
			Sys.println( str );
			#else
			if ( !StringTools.startsWith( infos.fileName, "hx/concurrent" ) ) {
				var str = haxe.Log.formatOutput( "\n\t\033[36m" + v, infos );
				Sys.println( "[CLIENT] " + str + "\033[0m" );
			}
			#end
		}

		// CompileTime.importPackage( "hrt" );

		#if !debug
		hl.UI.closeConsole();
		#end

		Util.hollowScene = new Scene();

		new ClientMain( s2d );
	}

	override function onResize() {
		super.onResize();
		dn.Process.resizeAll();
		onResizeSignal.dispatch();
	}

	override function update( dt : Float ) {
		this.deltaTime = dt;
		dn.Process.updateAll( hxd.Timer.tmod );

		super.update( dt );
	}

	public function createServer() {
		sys.thread.Thread.create(() -> {
			#if debug
			Sys.command( "hl bin/server.hl" );
			#else
			Sys.command( "hl.exe server.hl" );
			#end
		} );
	}
}
#end

class NameSystem extends System {

	@:add private function nameAdded( name : Name ) : Void {
		trace( 'name added: $name' );
	}

	@:update private function nameUpdated( name : Name ) : Void {
		trace( 'name updated: $name' );
	}

	@:remove private function nameRemoved( name : Name ) : Void {
		trace( 'name removed: $name' );
	}
}

@:echoes_replace
typedef Name = String;
