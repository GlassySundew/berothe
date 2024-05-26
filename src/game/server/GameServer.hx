package game.server;

import signals.Signal0;
import signals.Signal;
import game.core.rules.overworld.location.Location;
import game.data.storage.location.LocationDescription;
#if server
import dn.Process;
import en.Entity;
import hxbit.NetworkHost.NetworkClient;
import net.ClientController;
import net.Server;
import game.core.GameCore;
import game.data.storage.DataStorage;
import game.server.level.ObjectsProviderFactory;

using en.util.EntityUtil;

/**
	Логика игры на сервере
**/
@:build( util.Macros.buildNetworkMessageSignals( net.Message ) )
class GameServer extends Process {

	public static var inst : GameServer;

	final server : Server;
	final core : GameCore = new GameCore();

	public function new( server : Server ) {
		super();
		this.server = server;
		inst = this;

		// CompileTime.importPackage( "en" );
		CompileTime.importPackage( "hrt" );

		Data.load( hxd.Res.data.entry.getText() );
		new DataStorage();

		onClientAuthMessage.add( ( networkClient : NetworkClient ) -> {
			if ( networkClient.ownerObject != null ) return;

			var clientController = new ClientController( networkClient );
			networkClient.ownerObject = clientController;
			@:privateAccess server.host.register( clientController, networkClient.ctx );
			networkClient.sync();

			createPlayer();
			// entityFactory.createPlayer( "new player", clientController );
		} );

		#if debug
		onGetServerStatusMessage.add( ( client ) -> {
			server.host.sendMessage( net.Message.ServerStatus( server.host.isAuth ), client );
		} );
		#end
	}

	override function onDispose() {
		super.onDispose();

		for ( e in Entity.ServerALL ) e.destroy();
		gc();
	}

	public function getLevel( locationDesc : LocationDescription ) : Location {
		return core.getOrCreateLocationByDesc( locationDesc );
	}

	function createLevel( conf : Data.Location ) : ServerLevelController {
		var objectsProvider = ObjectsProviderFactory.create( conf );
		var level = new ServerLevelController( objectsProvider );
		objectsProvider.init( level );
		return level;
	}

	function gc() {
		if ( Entity.GC == null || Entity.GC.length == 0 )
			return;

		for ( e in Entity.GC ) e.dispose();
		Entity.GC = [];
	}

	function createPlayer() {
		var location = getLevel( DataStorage.inst.locationStorage.getStartLocationDescription() );

		var entity = location.entityFactory.createEntityBySpawnPointEntityType(
			DataStorage.inst.entityStorage.getPlayerDescription()
		);

		trace( entity );
	}

	override function update() {
		super.update();

		for ( e in Entity.ServerALL ) if ( !e.isDestroyed )
			e.headlessPreUpdate();
		for ( e in Entity.ServerALL ) if ( !e.isDestroyed )
			e.headlessUpdate();
		for ( e in Entity.ServerALL ) if ( !e.isDestroyed )
			e.headlessPostUpdate();
		for ( e in Entity.ServerALL ) if ( !e.isDestroyed )
			e.headlessFrameEnd();
		gc();
	}
}
#end
