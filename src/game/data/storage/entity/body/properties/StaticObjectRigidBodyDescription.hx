package game.data.storage.entity.body.properties;

import game.core.rules.overworld.entity.component.block.StaticObjectRigidBodyComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.EntityComponentReplicatorBase;
import game.core.rules.overworld.entity.EntityComponent;
import net.NetNode;

class StaticObjectRigidBodyDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_staticObjectRigidBody
	) : StaticObjectRigidBodyDescription {
		if ( entry == null ) return null;
		return new StaticObjectRigidBodyDescription( entry.id.toString() );
	}

	public function buildComponennt() : EntityComponent {
		return new StaticObjectRigidBodyComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
