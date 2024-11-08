package game.net;

import game.net.location.LocationReplicator;
import game.net.item.ItemReplicator;
import game.domain.overworld.item.Item;
import net.ClientController;
import game.net.entity.EntityReplicator;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.Chunk;
import util.Assert;
import game.domain.overworld.GameCore;
import game.domain.overworld.location.Location;

class CoreReplicator {

	public static var inst : CoreReplicator;

	public final locations : Map<String, LocationReplicator> = [];
	public final entities : Map<String, EntityReplicator> = [];
	public final items : Map<String, ItemReplicator> = [];

	final core : GameCore;

	public function new( core : GameCore ) {
		inst = this;
		this.core = core;
		core.onLocationCreated.add( onLocationCreated );
		core.onEntityCreated.add( onEntityCreated );
		core.onItemCreated.add( onItemCreated );
	}

	public inline function getEntityReplicator(
		entity : OverworldEntity
	) : EntityReplicator {
		return getEntityReplicatorById( entity.id );
	}

	public function getEntityReplicatorById(
		entityId : String
	) : EntityReplicator {
		var entityRepl = entities[entityId];
		Assert.notNull( entityRepl, 'entity replicator: $entityId is not found' );
		return entityRepl;
	}

	public function getLocationReplicator(
		location : Location
	) : LocationReplicator {
		var locationRepl = locations[location.id];
		Assert.notNull( locationRepl, 'location replication manager is not found' );
		return locationRepl;
	}

	public function getItemReplicator(
		item : Item
	) : ItemReplicator {
		var itemRepl = items[item.id];
		Assert.notNull( itemRepl, 'item replicator is not found' );
		return itemRepl;
	}

	function onLocationCreated( location : Location ) {
		#if debug
		Assert.notExistsInMap(
			location.id,
			locations,
			"location id interfere check failed in main replication module!"
		);
		#end
		locations[location.id] = new LocationReplicator( location, this );
	}

	function onEntityCreated( entity : OverworldEntity ) {
		var entityReplicator = new EntityReplicator( entity );
		entities[entity.id] = entityReplicator;

		// entity.location.addOnValue(
		// 	( oldLoc, newLocation ) -> {
		// 		if ( newLocation == null ) return;

		// 	}
		// );

		entityReplicator.followServer();
	}

	function onItemCreated( item : Item ) {
		#if debug
		Assert.notExistsInMap(
			item.id,
			items,
			"item id interfere check failed in main replication module!"
		);
		#end

		var itemReplicator = new ItemReplicator( item );
		items[item.id] = itemReplicator;
	}
}
