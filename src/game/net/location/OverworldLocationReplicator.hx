package game.net.location;

import game.net.ecs.systems.UnitReplicationSyncSystem;
import game.net.ecs.systems.UnitReplicationCreateSystem;
import game.net.ecs.systems.PlayerUnitReplicatorSpawnSystem;
import game.net.CoreReplicator;
import net.NetNode;
import game.domain.overworld.location.OverworldLocationMain;

// server-side
class OverworldLocationReplicator {

	public final locationDescriptionId : String;

	final location : OverworldLocationMain;
	final coreReplicator : CoreReplicator;

	var context : ILocationReplicatorContext;

	public function new( location : OverworldLocationMain, coreReplicator : CoreReplicator ) {

		this.locationDescriptionId = location.locationDesc.id;
		this.location = location;
		this.coreReplicator = coreReplicator;

		init();
	}

	public function dispose() {
		context.chunksReplicator.dispose();
	}

	function init() {

		initContext();
		initSystems();
	}

	function initContext() {

		context = new LocationReplicatorContext( location, coreReplicator );
		location.world.setService( ILocationReplicatorContext, context );
	}

	function initSystems() {

		final world = location.world;

		location.mainSystems
			.add( new PlayerUnitReplicatorSpawnSystem( world ) )
			.add( new UnitReplicationCreateSystem( world ) )

			.add( new UnitReplicationSyncSystem( world ) );
	}
}
