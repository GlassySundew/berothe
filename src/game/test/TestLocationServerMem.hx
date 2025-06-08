package game.test;

import game.data.storage.DataStorage;
import game.domain.depr.overworld.GameCoreDepr;

class TestLocationServerMem {

	static public function main() : Void {
		new TestLocationServerMem();
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

		hxd.System.start( function () {
			mainLoop();
			hxd.System.setLoop( mainLoop );

			hxd.Res.initLocal();
			Data.load( hxd.Res.data.entry.getText() );
			new DataStorage();

			test();

			#if !debug
			hl.UI.closeConsole();
			#end
		} );
	}

	function test() {
		var gameCore = new GameCoreDepr();

		var requester = gameCore.entityFactory.createEntity(
			DataStorage.inst.entityStorage.getPlayerDescription()
		);

		function createAndDestroyLocation() {
			haxe.Timer.delay(() -> {
				var location = gameCore.getOrCreateLocationByDesc(
					DataStorage.inst.locationStorage.getStartLocationDescription(),
					requester,
					true
				);

				trace( "location created" );

				haxe.Timer.delay(() -> {
					trace( "location destroyed" );
					location.dispose();

					@:privateAccess
					trace( Lambda.count( gameCore.locationContainers ) );
					@:privateAccess
					for ( con in gameCore.locationContainers ) {
						trace( con );
					}

					createAndDestroyLocation();
				}, 2 );
			}, 1 );
		}

		createAndDestroyLocation();
	}
}
