package game.net.server;

import game.domain.overworld.config.EntityCreationConfig;
import game.domain.overworld.GameCore;
import hxd.Timer;
#if server
import dn.Process;
import hxbit.NetworkHost.NetworkClient;
import net.ClientController;
import net.Server;
import game.data.storage.DataStorage;
import game.data.storage.location.LocationDescription;
import game.domain.depr.overworld.GameCoreDepr;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Location;
import game.net.entity.EntityReplicator;
import game.net.CoreReplicator;
import game.net.player.PlayerReplicationService;

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

	public final core = new GameCore();
	final server : Server;

	public function new( server : Server ) {
		super();
		this.server = server;
		inst = this;

		// CompileTime.importPackage( "en" );
		// CompileTime.importPackage( "hrt" );

		Data.load( hxd.Res.data.entry.getText() );
		new DataStorage();

		onClientAuthMessage.add( onNewClientConnected );
		server.onClientDisconnected.add( onClientDisconnected );
	}

	public function getLevel(
		locationDesc : LocationDescription,
		requesterEntityId : String
	) : Location {
		return core.getOrCreateLocationByDesc( locationDesc, requesterEntityId, true );
	}

	function createPlayer() {

		var playerCreationConfig = new EntityCreationConfig(
			DataStorage.inst.entityStorage.getPlayerDescription()
		);

		var location = getLevel(
			DataStorage.inst.locationStorage.getStartLocationDescription(),
			""
		);

		location.context.entityCreationQueue.push( playerCreationConfig );
	}

	function onNewClientConnected( networkClient : NetworkClient ) {

		if ( networkClient.ownerObject != null ) return;

		var clientController = new ClientController( networkClient );
		networkClient.ownerObject = clientController;
		@:privateAccess server.host.register( clientController, networkClient );
		networkClient.sync();

		createPlayer();
	}

	override function update() {

		core.update();
	}

	function onClientDisconnected( cliCon : ClientController ) {
		// cliCon.playerReplService.onClientDisconnected();
	}
}
#end
