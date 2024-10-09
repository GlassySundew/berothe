package game.data.storage.entity.body.properties;

import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.component.EntityRigidBodyComponent;
import game.data.storage.entity.body.properties.VolumetricBodyDescriptionBase;
import game.net.entity.EntityComponentReplicatorBase;
import game.net.entity.component.EntityRigidBodyComponentReplicator;

class RigidBodyTorsoDescription extends VolumetricBodyDescriptionBase {

	public inline static function fromCdb(
		entry : Data.EntityProperty_properties_rigidBodyTorso
	) : RigidBodyTorsoDescription {
		if ( entry == null ) return null;

		return new RigidBodyTorsoDescription(
			entry.offsetX,
			entry.offsetY,
			entry.offsetZ,
			entry.sizeX,
			entry.sizeY,
			entry.sizeZ,
			entry.hasFeet,
			entry.id.toString()
		);
	}

	public final hasFeet : Bool;

	public function new(
		offsetX : Float,
		offsetY : Float,
		offsetZ : Float,
		sizeX : Float,
		sizeY : Float,
		sizeZ : Float,
		hasFeet : Bool,
		id : String
	) {
		super(
			offsetX,
			offsetY,
			offsetZ,
			sizeX,
			sizeY,
			sizeZ,
			id,
		);
		this.hasFeet = hasFeet;
	}

	public function buildComponent() : EntityComponent {
		return new EntityRigidBodyComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		return new EntityRigidBodyComponentReplicator( parent );
	}
}
