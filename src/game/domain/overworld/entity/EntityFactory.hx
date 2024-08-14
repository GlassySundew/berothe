package game.domain.overworld.entity;

import util.Assert;
import signals.Signal;
import game.data.location.objects.LocationSpawn;
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
			// Assert.notNull( component, "null component came from body property factory" );
			if ( component != null )
				entity.components.add( component );
		}
	}
	
	static var ENTITY_ID_STUB = 0;

	public final onEntityCreated = new Signal<OverworldEntity>();

	public function new() {}

	public function createEntityBySpawnPointEntityDesc(
		location : Location,
		entityDesc : EntityDescription
	) : OverworldEntity {
		var spawnPointDesc : LocationSpawn = location.getSpawnByEntityDesc( entityDesc );

		var entity = createEntity( entityDesc );
		entity.transform.setPosition(
			spawnPointDesc.x,
			spawnPointDesc.y,
			spawnPointDesc.z
		);
		return entity;
	}

	function createEntity( entityDesc : EntityDescription ) : OverworldEntity {
		var entity = new OverworldEntity( entityDesc, '${++ENTITY_ID_STUB}' );
		createAndAttachComponentsFromProperties( entityDesc, entity );

		onEntityCreated.dispatch( entity );

		return entity;
	}


}
