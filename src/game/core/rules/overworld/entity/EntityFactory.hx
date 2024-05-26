package game.core.rules.overworld.entity;

import game.data.location.objects.LocationSpawnDescription;
import game.data.storage.entity.EntityDescription;
import game.core.rules.overworld.location.Location;
import game.data.storage.entity.body.EntityBodyDescription;

class EntityFactory {

	var location : Location;

	public function new( location : Location ) {
		this.location = location;
	}

	public function createEntityBySpawnPointEntityType( entityDesc : EntityDescription ) : OverworldEntity {
		var spawnPointDesc : LocationSpawnDescription = location.getSpawnByEntityType( entityDesc );

		var entity = createEntity( entityDesc );
		entity.transform.setTransform(
			spawnPointDesc.x,
			spawnPointDesc.y,
			spawnPointDesc.z
		);
		addEntityOntoLocation( entity );
		return entity;
	}

	function createEntity( entityDesc : EntityDescription ) : OverworldEntity {
		var entity = new OverworldEntity( entityDesc );
		return entity;
	}

	function addEntityOntoLocation( entity : OverworldEntity ) {
		location.addEntity( entity );
	}
}
