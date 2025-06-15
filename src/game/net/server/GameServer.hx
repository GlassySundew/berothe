package game.net.server;

#if server
import dn.Process;
import echoes.Entity;
import hxbit.NetworkHost.NetworkClient;
import net.ClientController;
import net.Server;
import game.data.storage.DataStorage;
import game.data.storage.location.LocationDescription;
import game.domain.overworld.GameCore;
import game.domain.overworld.config.EntityCreationConfig;
import game.domain.overworld.location.OverworldLocationMain;
import game.domain.overworld.ecs.components.units.UnitTags.UnitSpawnRequest;
import game.net.entity.EntityReplicator;

/**
	Логика игры на сервере
**/
@:build( util.Macros.buildNetworkMessageSignals( net.Message ) )
class GameServer extends Process {

	final core : GameCore;
	final coreReplicator : CoreReplicator;
	final server : Server;

	public function new( server : Server ) {

		super();
		this.server = server;
		this.core = new GameCore();
		this.coreReplicator = new CoreReplicator( core );

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
	) : OverworldLocationMain {
		return core.getOrCreateLocationByDesc( locationDesc, requesterEntityId, true );
	}

	function onNewClientConnected( networkClient : NetworkClient ) {

		if ( networkClient.ownerObject != null ) return;

		var clientController = new ClientController( networkClient );
		networkClient.ownerObject = clientController;
		@:privateAccess server.host.register( clientController, networkClient );
		networkClient.sync();

		final repl = new EntityReplicator();

		createPlayerEntity( clientController );
	}

	function createPlayerEntity( clientController : ClientController ) {

		var playerCreationConfig = new EntityCreationConfig(
			DataStorage.inst.entityStorage.getPlayerDescription()
		);
		playerCreationConfig.clientController = clientController;

		var location = getLevel(
			DataStorage.inst.locationStorage.getStartLocationDescription(),
			""
		);

		location.context.entitySpawnConfigs.add( playerCreationConfig );
		final configIdx = location.context.entitySpawnConfigs.length - 1;

		final entity = new Entity( location.world );
		final world = location.world;
		entity.add( world, ( { configId : configIdx } : UnitSpawnRequest ) );
	}

	override function update() {

		core.update();
	}

	function onClientDisconnected( cliCon : ClientController ) {
		// cliCon.playerReplService.onClientDisconnected();
	}
}
#end
