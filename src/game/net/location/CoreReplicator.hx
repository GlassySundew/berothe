package game.net.location;

import net.ClientController;
import game.net.entity.EntityReplicator;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Chunk;
import util.Assert;
import game.domain.GameCore;
import game.domain.overworld.location.Location;

class CoreReplicator {

	final locations : Map<String, LocationReplicator> = [];
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

	public function getLocationReplicator(
		location : Location
	) : LocationReplicator {
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
		locations[location.id] = new LocationReplicator( location, this );
	}

	function onEntityCreated( entity : OverworldEntity ) {
		var entityReplicator = new EntityReplicator( entity );
		entities[entity.id] = entityReplicator;

		entity.location.onAppear(
			( location ) -> entityReplicator.addChild( locations[location.id] )
		);
	}
}
