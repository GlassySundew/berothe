package game.net.server;

#if server
import dn.Process;
import hxbit.NetworkHost.NetworkClient;
import net.ClientController;
import net.Server;
import game.data.storage.DataStorage;
import game.data.storage.location.LocationDescription;
import game.domain.overworld.GameCore;
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

	public function getLevel( locationDesc : LocationDescription ) : Location {
		return core.getOrCreateLocationByDesc( locationDesc, true );
	}

	function createPlayer() : EntityReplicator {
		var location = getLevel(
			DataStorage.inst.locationStorage.getStartLocationDescription()
		);

		var entity = core.entityFactory.createEntityBySpawnPointEntityDesc(
			location,
			DataStorage.inst.entityStorage.getPlayerDescription()
		);

		return coreReplicator.getEntityReplicator( entity );
	}

	function preparePlayer(
		playerEntity : OverworldEntity,
		playerReplicator : EntityReplicator,
		cliCon : ClientController
	) : PlayerReplicationService {
		return
			new PlayerReplicationService(
				playerEntity,
				playerReplicator,
				cliCon,
				coreReplicator
			);
	}

	function onNewClientConnected( networkClient : NetworkClient ) {
		if ( networkClient.ownerObject != null ) return;

		var clientController = new ClientController( networkClient );
		networkClient.ownerObject = clientController;
		@:privateAccess server.host.register( clientController, networkClient );
		networkClient.sync();

		var playerReplicator = createPlayer();

		playerReplicator.entity.then( ( playerEntity ) ->
			var playerReplManager = preparePlayer( playerEntity, playerReplicator, clientController )
		);
	}

	override function update() {
		core.update( tmod / hxd.Timer.wantedFPS, tmod );
	}
}
#end
