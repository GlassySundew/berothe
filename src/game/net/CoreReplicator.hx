package game.net;

import util.Assert;
import game.domain.overworld.GameCore;
import game.domain.overworld.location.OverworldLocationMain;
import game.net.location.OverworldLocationReplicator;
#if macro
import haxe.macro.Expr;
#end

class CoreReplicator {

	public static var inst : CoreReplicator;

	public final locations : Map<String, LocationReplicator> = [];
	public final entities : Map<String, EntityReplicator> = [];
	public final items : Map<String, ItemReplicator> = [];

	final core : GameCoreDepr;

	public function new( core : GameCoreDepr ) {
		inst = this;
		this.core = core;
		// core.onLocationCreated.add( onLocationCreated );
		// core.onEntityCreated.add( onEntityCreated );
		// core.onItemCreated.add( onItemCreated );

		// this.blahblah(this);
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
		Assert.notNull( itemRepl, item + ' replicator is not found' );
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
		// location.disposed.then( _ -> {
		// 	locations[location.id].dispose();
		// 	locations.remove( location.id );
		// } );
	}

	function onEntityCreated( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInMap(
			entity.id,
			entities,
			"entity id interfere check failed in main replication module!"
		);
		#end
		var entityReplicator = new EntityReplicator( entity );
		entities[entity.id] = entityReplicator;
		entity.postDisposed.then( _ -> entities.remove( entity.id ) );

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
		item.disposed.then( _ -> {
			items.remove( item.id );
		} );
	}
}
