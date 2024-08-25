package game.domain.overworld.entity;

import util.Assert;
import signals.Signal;
import game.data.location.objects.LocationSpawnVO;
import game.data.storage.entity.EntityDescription;
import game.domain.overworld.location.Location;

class EntityFactory {

	public static function createAndAttachComponentsFromProperties(
		entityDesc : EntityDescription,
		entity : OverworldEntity
	) {
		var properties = entityDesc.getBodyDescription();
		var components = EntityComponentsFactory.fromPropertyDescription( properties );
		for ( component in components ) {
			Assert.notNull( component, "null component came from body property factory" );
			if ( component != null )
				entity.components.add( component );
		}
	}

	static var ENTITY_ID_STUB = 0;

	public final onEntityCreated = new Signal<OverworldEntity>();

	public function new() {}

	/**
		call this when we do not care by which spawnpoint entity will be created
	**/
	public function createEntityBySpawnPointEntityDesc(
		location : Location,
		entityDesc : EntityDescription
	) : OverworldEntity {
		var spawnPointDesc : LocationSpawnVO = location.getSpawnByEntityDesc( entityDesc );

		var entity = createEntity( entityDesc );
		entity.transform.setPosition(
			spawnPointDesc.x,
			spawnPointDesc.y,
			spawnPointDesc.z
		);
		location.addEntity( entity );
		return entity;
	}

	public function createEntity( entityDesc : EntityDescription ) : OverworldEntity {
		var entity = new OverworldEntity( entityDesc, '${++ENTITY_ID_STUB}' );
		createAndAttachComponentsFromProperties( entityDesc, entity );

		onEntityCreated.dispatch( entity );

		return entity;
	}
}
