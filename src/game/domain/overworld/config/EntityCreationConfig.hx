package game.domain.overworld.config;

import game.domain.overworld.config.components.EntityBaseStatConfig;
import game.data.storage.entity.EntityDescription;

/**
	Mutable DTO for entity instancing, can and will be changed
	to alter entity state before creation
**/
class EntityCreationConfig {

	public var baseStats( default, null ) : EntityBaseStatConfig;

	public inline function new( entityDesc : EntityDescription ) {

		initFromEntityDesc( entityDesc );
	}

	public inline function initFromEntityDesc( entityDesc : EntityDescription ) {

		final bodyDescription = entityDesc.getBodyDescription();

		baseStats = new EntityBaseStatConfig( bodyDescription.model );
	}
}
