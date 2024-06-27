package game.server;

import game.net.entity.EntityReplicator;
import game.net.location.CoreReplicator;
import game.core.rules.overworld.location.Chunk;
import game.net.player.PlayerReplicationManager;
import game.core.rules.overworld.entity.OverworldEntity;
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

	public static var inst( default, set ) : GameServer;
	static function set_inst( game : GameServer ) {
		if ( inst != null ) {
			inst.destroy();
			@:privateAccess Process._garbageCollector( Process.ROOTS );
		}
		return inst = game;
	}

	final server : Server;
	final core : GameCore = new GameCore();
	final coreReplicator : CoreReplicator;

	public function new( server : Server ) {
		super();
		this.server = server;
		inst = this;

		// CompileTime.importPackage( "en" );
		CompileTime.importPackage( "hrt" );

		Data.load( hxd.Res.data.entry.getText() );
		new DataStorage();

		coreReplicator = new CoreReplicator( core );

		onClientAuthMessage.add( onNewClientConnected );

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

	function createPlayer() : EntityReplicator {
		var location = getLevel(
			DataStorage.inst.locationStorage.getStartLocationDescription()
		);

		var entity = core.entityFactory.createEntityBySpawnPointEntityDesc(
			location,
			DataStorage.inst.entityStorage.getPlayerDescription()
		);
		location.addEntity( entity );

		return coreReplicator.getEntityReplicator( entity );
	}

	function preparePlayer(
		playerEntity : OverworldEntity,
		playerReplicator : EntityReplicator,
		cliCon : ClientController
	) : PlayerReplicationManager {
		return
			new PlayerReplicationManager(
				playerEntity,
				playerReplicator,
				cliCon,
				coreReplicator
			);
	}

	function gc() {
		if ( Entity.GC == null || Entity.GC.length == 0 )
			return;

		for ( e in Entity.GC ) e.dispose();
		Entity.GC = [];
	}

	override function update() {
		super.update();

		for ( e in Entity.ServerALL ) if ( !e.isDestroyed ) e.headlessPreUpdate();
		for ( e in Entity.ServerALL ) if ( !e.isDestroyed ) e.headlessUpdate();
		for ( e in Entity.ServerALL ) if ( !e.isDestroyed ) e.headlessPostUpdate();
		for ( e in Entity.ServerALL ) if ( !e.isDestroyed ) e.headlessFrameEnd();
		gc();
	}

	function onNewClientConnected( networkClient : NetworkClient ) {
		if ( networkClient.ownerObject != null ) return;

		var clientController = new ClientController( networkClient );
		networkClient.ownerObject = clientController;
		@:privateAccess server.host.register( clientController, networkClient.ctx );
		networkClient.sync();

		var playerReplicator = createPlayer();

		var playerReplManager = preparePlayer( playerReplicator.entity, playerReplicator, clientController );

		// entityFactory.createPlayer( "new player", clientController );
	}
}
#end
