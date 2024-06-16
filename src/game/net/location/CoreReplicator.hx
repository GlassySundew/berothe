package game.net.location;

import net.ClientController;
import game.net.entity.EntityReplicator;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.location.Chunk;
import util.Assert;
import game.core.GameCore;
import game.core.rules.overworld.location.Location;

class CoreReplicator {

	final locations : Map<String, LocationReplicationManager> = [];
	final entities : Map<String, EntityReplicator> = [];

	final core : GameCore;

	public function new( core : GameCore ) {
		this.core = core;
		core.onLocationCreated.add( onLocationCreated );
	}

	public function getEntityReplicator(
		entity : OverworldEntity
	) : EntityReplicator {
		var entityRepl = entities[entity.id];
		Assert.notNull( entityRepl, "entity replicator is not found when creating sync bridge" );
		return entityRepl;
	}

	public function getLocationReplicationManager(
		location : Location
	) : LocationReplicationManager {
		var locationRepl = locations[location.id];
		Assert.notNull( locationRepl, "location replication manager is not found when creating sync bridge" );
		return locationRepl;
	}

	function onLocationCreated( location : Location ) {
		#if debug
		Assert.notExistsInMap(
			location.id,
			locations,
			"location id interfere check failed in main replication module!"
		);
		#end
		core.onEntityCreated.add( onEntityCreated );
		locations[location.id] = new LocationReplicationManager( location, this );
	}

	function onEntityCreated( entity : OverworldEntity ) {
		entities[entity.id] = new EntityReplicator( entity );
	}
}
