package game.data.storage.entity.body.properties;

import game.net.entity.EntityComponentReplicatorBase;
import game.core.rules.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityModelDescription extends EntityComponentDescription {

	public static function fromCdb(
		desc : Data.EntityProperty_properties_model
	) : EntityModelDescription {
		var equipmentSet = new Map()
		for ( key in desc.equipment ) {}

		return new EntityModelDescription();
	}

	public function new( id : String ) {
		super( id );
	}

	public function buildComponennt() : EntityComponent {
		throw new haxe.exceptions.NotImplementedException();
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
