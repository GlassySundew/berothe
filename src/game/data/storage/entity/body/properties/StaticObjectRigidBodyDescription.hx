package game.data.storage.entity.body.properties;

import game.data.storage.entity.component.EntityComponentDescription;

class StaticObjectRigidBodyDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityPropertySetup_properties_staticObjectRigidBody
	) : StaticObjectRigidBodyDescription {
		if ( entry == null ) return null;
		return new StaticObjectRigidBodyDescription( entry.id.toString() );
	}
}
