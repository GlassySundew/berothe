package game.domain.overworld.config;

import h3d.Vector;
import net.ClientController;
import game.domain.overworld.config.components.EntityBaseStatConfig;
import game.data.storage.entity.EntityDescription;

/**
	Mutable DTO for entity instancing, can and will be changed
	to alter entity state before creation
**/
class EntityCreationConfig {

	public var baseStats( default, null ) : EntityBaseStatConfig;
	public var isDynamic( default, null ) : Bool;
	public var position( default, null ) : Vector = new Vector();
	public var velocity( default, null ) : Vector = new Vector();

	public var clientController : ClientController;

	public inline function new( entityDesc : EntityDescription ) {

		initFromEntityDesc( entityDesc );
	}

	public inline function initFromEntityDesc( entityDesc : EntityDescription ) {

		final bodyDescription = entityDesc.getBodyDescription();

		baseStats = new EntityBaseStatConfig( bodyDescription.model );
		isDynamic = entityDesc.getBodyDescription().dynamics != null;
	}
}
