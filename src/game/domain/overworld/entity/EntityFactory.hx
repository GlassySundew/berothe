package game.domain.overworld.entity;

import game.data.storage.entity.component.EntityComponentDescription;
import util.Assert;
import signals.Signal;
import game.data.location.objects.LocationSpawnVO;
import game.data.storage.entity.EntityDescription;
import game.domain.overworld.location.Location;

class EntityFactory {

	static var ENTITY_ID_STUB = 0;

	public static function createAndAttachClientComponentsFromProperties(
		entityDesc : EntityDescription,
		entity : OverworldEntity
	) {
		var properties = entityDesc.getBodyDescription();
		createAndAttachComps(
			entityDesc,
			entity,
			properties.clientPropertyDescs
		);
	}

	public static function createAndAttachComponentsFromProperties(
		entityDesc : EntityDescription,
		entity : OverworldEntity
	) {
		var properties = entityDesc.getBodyDescription();
		createAndAttachComps(
			entityDesc,
			entity,
			properties.propertyDescs
		);
	}

	static function createAndAttachComps(
		entityDesc : EntityDescription,
		entity : OverworldEntity,
		compDescs : Array<EntityComponentDescription>
	) {
		var components = EntityComponentsFactory.fromPropertyDescriptions( compDescs );

		for ( component in components ) {
			Assert.notNull( component, "null component came from body property factory" );
			if ( component != null )
				entity.components.add( component );
		}
	}

	public final onEntityCreated = new Signal<OverworldEntity>();

	public function new() {}

	/**
		call this when we do not care by which spawnpoint entity will be created
	**/
	// public function placeEntityBySpawnPointEntityDesc(
	// 	location : Location,
	// 	entity : OverworldEntity
	// ) {
	// 	var entityDesc = entity.desc;
	// 	var spawnPointDesc : LocationSpawnVO = location.getSpawnByEntityDesc( entityDesc );

	// 	entity.transform.setPosition(
	// 		spawnPointDesc.x,
	// 		spawnPointDesc.y,
	// 		spawnPointDesc.z
	// 	);
	// 	entity.transform.setRotation(
	// 		0, 0, spawnPointDesc.rotationZ
	// 	);
	// 	location.addEntity( entity );
	// }

	public function createEntity( entityDesc : EntityDescription ) : OverworldEntity {
		var entity = new OverworldEntity( entityDesc, '${++ENTITY_ID_STUB}' );
		createAndAttachComponentsFromProperties( entityDesc, entity );

		onEntityCreated.dispatch( entity );

		for ( comp in entity.components.container ) {
			comp.claimOwnage();
		}

		return entity;
	}
}
