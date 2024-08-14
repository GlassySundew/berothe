package game.data.storage.entity.body.model;

import game.domain.overworld.entity.component.EntityModelComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityModelDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_model
	) : EntityModelDescription {
		if ( entry == null ) return null;

		return new EntityModelDescription(
			entry.id.toString()
		);
	}

	public function new( id : String ) {
		super( id );
	}

	public function buildComponennt() : EntityComponent {
		return new EntityModelComponent(this);
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
