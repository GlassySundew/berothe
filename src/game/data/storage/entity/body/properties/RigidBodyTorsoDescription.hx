package game.data.storage.entity.body.properties;

import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.component.EntityRigidBodyComponent;
import game.data.storage.entity.body.properties.VolumetricBodyDescriptionBase;
import game.net.entity.EntityComponentReplicatorBase;
import game.net.entity.component.EntityRigidBodyComponentReplicator;

enum GeometryType {
	BOX;
	CAPSULE;
}

class RigidBodyTorsoDescription extends VolumetricBodyDescriptionBase {

	public inline static function fromCdb(
		entry : Data.EntityPropertySetup_properties_rigidBodyTorso
	) : RigidBodyTorsoDescription {
		if ( entry == null ) return null;

		var geometry = switch entry.geometry {
			case box: BOX;
			case capsule:
				if ( entry.sizeY != null && entry.sizeY != 0 )
					trace( "WARNING: rigid body capsule geometry does not take sizeY param, id: " + entry.id );
				CAPSULE;
		}

		return new RigidBodyTorsoDescription(
			geometry,
			entry.offsetX,
			entry.offsetY,
			entry.offsetZ,
			entry.sizeX,
			entry.sizeY,
			entry.sizeZ,
			entry.hasFeet,
			entry.isStatic,
			entry.id.toString()
		);
	}

	public final hasFeet : Bool;
	public final isStatic : Bool;
	public final geometry : GeometryType;

	public function new(
		geometry : GeometryType,
		offsetX : Float,
		offsetY : Float,
		offsetZ : Float,
		sizeX : Float,
		sizeY : Float,
		sizeZ : Float,
		hasFeet : Bool,
		isStatic : Bool,
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
		this.geometry = geometry;
		this.hasFeet = hasFeet;
		this.isStatic = isStatic;
	}

	public function buildComponent() : EntityComponent {
		return new EntityRigidBodyComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		return new EntityRigidBodyComponentReplicator( parent );
	}
}
