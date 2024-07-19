package game.data.storage.entity.body.properties;

import net.NetNode;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.component.EntityRigidBodyComponent;
import game.data.storage.entity.body.properties.VolumetricBodyDescriptionBase;
import game.net.entity.EntityComponentReplicator;
import game.net.entity.component.EntityRigidBodyComponentReplicator;

class RigidBodyTorsoDescription extends VolumetricBodyDescriptionBase {

	public inline static function fromCdb(
		entry : Data.EntityProperty_properties_rigidBodyTorso
	) : RigidBodyTorsoDescription {
		if ( entry == null ) return null;
		return new RigidBodyTorsoDescription(
			0,
			0,
			entry.offsetZ,
			entry.sizeX,
			entry.sizeY,
			entry.sizeZ,
			entry.id.toString()
		);
	}

	public function buildComponennt() : EntityComponent {
		return new EntityRigidBodyComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicator {
		return new EntityRigidBodyComponentReplicator( parent );
	}
}
