package game.server.level.spawn;

import en.Entity;
import game.server.level.prefab.mediator.PrefabObjectMediator;
import game.server.level.prefab.mediator.IPrefabObject;
import hrt.prefab.l3d.Instance;

class EntitySpawnPoint implements IPrefabObject {

	public final name : String;

	var x : Int;
	var y : Int;
	var z : Int;

	var entityCdb : Data.EntityBody;
	var mediator : PrefabObjectMediator;

	public function new(
		mediator : PrefabObjectMediator,
		entityCdb : Data.EntityBody
	) {
		this.entityCdb = entityCdb;
		this.mediator = mediator;
		var instance : Instance = Std.downcast( mediator.prefab, Instance );

		this.x = Std.int( instance.x );
		this.y = Std.int( instance.y );
		this.z = Std.int( instance.z );

		name = instance.name;
	}

	public function initPrefab() {
		// mediator.level.entitySpawns.addSpawn( this );
	}

	// public function spawnEntity( overrideEntityType : Class<Entity> = null ) : Entity {
	// 	var entity = GameServer.inst.entityFactory.createEntity(
	// 		entityCdb.id,
	// 		overrideEntityType
	// 	);
	// 	entity.setPosRpc( x, y, z );
	// 	mediator.level.attachEntity( entity );
	// 	return entity;
	// }
}
