package game.data.storage.entity.body;

import game.data.storage.entity.body.model.EntityModelDescription;
import game.client.en.comp.auxil.EntityMountPointsComponent;
import game.data.storage.entity.body.auxil.EntityMountPointsDescription;
import util.extensions.ArrayExtensions;
import game.data.storage.DescriptionBase;
import game.data.storage.entity.body.properties.AttackListDescription;
import game.data.storage.entity.body.properties.DynamicsDescription;
import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.entity.body.properties.StaticObjectRigidBodyDescription;
import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.body.view.EntityViewDescriptionAbstractFactory;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityPropertiesDescription extends DescriptionBase {

	public var propertyDescriptions( default, null ) : Array<EntityComponentDescription> = [];

	public var dynamics( default, null ) : Null<DynamicsDescription>;
	public var rigidBodyTorsoDesc( default, null ) : Null<RigidBodyTorsoDescription>;
	public var staticRigidBodyDecs( default, null ) : Null<StaticObjectRigidBodyDescription>;
	public var bodyHitbox( default, null ) : Null<HitboxBodyDescription>;
	public var attackDesc( default, null ) : Null<AttackListDescription>;

	public var model : Null<EntityModelDescription>;
	public var view : Null<EntityViewDescription>;

	public function new( entry : Data.EntityPreset ) {
		super( entry.id.toString() );

		createPropDescriptions( entry );

		for ( propertyDesc in propertyDescriptions ) {
			DataStorage.inst.entityPropertiesStorage.provideExistingDescription( propertyDesc );
		}
	}

	function createPropDescriptions( entry : Data.EntityPreset ) {
		propertyDescriptions = ArrayExtensions.deNullify(( [

			rigidBodyTorsoDesc = RigidBodyTorsoDescription.fromCdb( entry.properties.properties.rigidBodyTorso ),
			staticRigidBodyDecs = StaticObjectRigidBodyDescription.fromCdb( entry.properties.properties.staticObjectRigidBody ),
			bodyHitbox = HitboxBodyDescription.fromCdb( entry.properties.properties.bodyHitbox ),
			attackDesc = AttackListDescription.fromCdb( entry.properties.properties.attack ),

			entry.properties.properties.dynamics ? dynamics = new DynamicsDescription() : null,

			model = EntityModelDescription.fromCdb( entry.properties.properties.model ),
			view = EntityViewDescriptionAbstractFactory.fromCdb( entry.view )

		] : Array<EntityComponentDescription> ) );
	}
}
