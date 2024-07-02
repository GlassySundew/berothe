package game.data.storage.entity.body;

import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.body.view.EntityViewDescriptionAbstractFactory;
import game.data.storage.entity.body.view.IEntityView;
import util.extensions.ArrayExtensions;
import game.data.storage.DescriptionBase;
import game.data.storage.entity.body.properties.DynamicsDescription;
import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.entity.body.properties.StaticObjectRigidBodyDescription;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityBodyDescription extends DescriptionBase {

	public var propertyDescriptions( default, null ) : Array<EntityComponentDescription> = [];

	public var rigidBodyTorsoDesc( default, null ) : Null<RigidBodyTorsoDescription>;
	public var bodyHitbox( default, null ) : Null<HitboxBodyDescription>;
	public var dynamics( default, null ) : Null<DynamicsDescription>;
	public var staticRigidBodyDecs( default, null ) : Null<StaticObjectRigidBodyDescription>;

	public var view : EntityViewDescription;

	public function new( entry : Data.EntityBody ) {
		super( entry.id.toString() );

		createPropDescriptions( entry );
		for ( propertyDesc in propertyDescriptions ) {
			DataStorage.inst.entityPropertiesStorage.provideExistingDescription( propertyDesc );
		}
	}

	function createPropDescriptions( entry : Data.EntityBody ) {
		propertyDescriptions = ArrayExtensions.deNullify(( [

			rigidBodyTorsoDesc = RigidBodyTorsoDescription.fromCdb( entry.properties.rigidBodyTorso ),
			bodyHitbox = HitboxBodyDescription.fromCdb( entry.properties.bodyHitbox ),
			staticRigidBodyDecs = StaticObjectRigidBodyDescription.fromCdb( entry.properties.staticObjectRigidBody ),

			entry.properties.dynamics ? dynamics = new DynamicsDescription() : null,

			view = EntityViewDescriptionAbstractFactory.fromCdb( entry.view )

		] : Array<EntityComponentDescription> ) );
	}
}
