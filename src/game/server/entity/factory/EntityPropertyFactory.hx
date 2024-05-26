package game.server.entity.factory;

import en.comp.net.EntityHitboxComponent;
import en.Entity;
import en.comp.net.EntityDynamicsComponent;
import en.comp.net.EntityRigidBodyComponent;
import h3d.Vector;

enum abstract EntityProperty( String ) from String {

	var rigidBodyTorso;
	var dynamics;
}

class EntityPropertyFactory {

	#if !debug inline #end
	public static function fromCdbProperties(
		entity : Entity,
		properties : Data.Entity_properties
	) {
		if ( properties.dynamics ) {
			entity.components.add( new EntityDynamicsComponent( entity ) );
		}

		if ( properties.rigidBodyTorso != null ) {
			entity.components.add(
				new EntityRigidBodyComponent(
					properties.rigidBodyTorso.offsetZ,
					properties.rigidBodyTorso.sizeX,
					properties.rigidBodyTorso.sizeY,
					properties.rigidBodyTorso.sizeZ,
					entity
				)
			);
		} else {
			// todo no body
		}

		if ( properties.bodyHitbox != null ) {
			entity.components.add(
				new EntityHitboxComponent(
					properties.bodyHitbox.offsetZ,
					properties.bodyHitbox.sizeX,
					properties.bodyHitbox.sizeY,
					properties.bodyHitbox.sizeZ,
					entity
				)
			);
		}
	}
}
