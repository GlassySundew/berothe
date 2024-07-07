import rx.disposables.Composite;
import graphics.ThreeDObjectNode;
import rx.schedulers.Test.TestBase;
import oimo.common.Vec3;
import oimo.m.IVec3;
import core.ClassMap;
import rx.Observable;
import rx.ObservableFactory;
import rx.Observer;
import rx.Scheduler;
import rx.Subscription;
import rx.observables.MakeScheduled.SubscribeInterval;
import rx.observables.Throttle;
import rx.observers.IObserver;
import rx.subjects.Replay;
#if client
import h2d.Scene;
import pass.CustomRenderer;
import signals.Signal;
import util.Env;
import util.Repeater;
import util.Util;
import util.tools.Save;

class Boot extends hxd.App {

	public static var inst( default, null ) : Boot;

	public var root3D( default, null ) : ThreeDObjectNode;

	public var renderer : CustomRenderer;
	public var deltaTime( default, null ) : Float;

	public var onResizeSignal : Signal = new Signal();

	static function main() {
		new Boot();
	}

	public function new() {
		inst = this;
		super();
	}

	override function setup() {
		super.setup();
		root3D = ThreeDObjectNode.fromHeapsObject( s3d );
	}

	// Engine ready
	override function init() {
		Env.init();
		Save.initFields();
		new Repeater( hxd.Timer.wantedFPS );

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

		CompileTime.importPackage( "hrt" );

		#if !debug
		hl.UI.closeConsole();
		#end

		Util.hollowScene = new Scene();

		new Main( s2d );

		onResize();
	}

	override function onResize() {
		super.onResize();
		dn.Process.resizeAll();
		onResizeSignal.dispatch();
	}

	var speed = 1.0;

	override function update( dt : Float ) {
		this.deltaTime = dt;
		var tmod = hxd.Timer.tmod * speed;
		dn.Process.updateAll( tmod );
		super.update( dt );
	}

	public function createServer() {
		sys.thread.Thread.create(() -> {
			#if debug
			Sys.command( "hl bin/server.hl" );
			#else
			Sys.command( "./hl server.hl" );
			#end
		} );
	}
}
#end
