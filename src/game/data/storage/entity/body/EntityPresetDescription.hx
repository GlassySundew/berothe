package game.data.storage.entity.body;

import game.domain.overworld.item.model.EntityOfItemComponent;
import game.data.storage.item.EntityOfItemComponentDescription;
import game.domain.overworld.entity.component.ai.EntityAIComponent;
import game.data.storage.entity.body.properties.EntityAIDescription;
import util.extensions.ArrayExtensions;
import game.data.storage.DescriptionBase;
import game.data.storage.entity.body.model.EntityModelDescription;
import game.data.storage.entity.body.properties.AttackListDescription;
import game.data.storage.entity.body.properties.DynamicsDescription;
import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.data.storage.entity.body.properties.InteractableDescription;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.entity.body.properties.StaticObjectRigidBodyDescription;
import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.component.EntityComponentDescription;
#if client
import game.data.storage.entity.body.view.EntityViewComponentExtensionsFactory;
import game.data.storage.entity.body.view.EntityViewDescriptionAbstractFactory;
import game.data.storage.entity.body.view.EntityLightSourceDescription;
#end

class EntityPresetDescription extends DescriptionBase {

	public final map : Map<String, EntityComponentDescription> = [];

	public var propertyDescs( default, null ) : Array<EntityComponentDescription> = [];
	public var clientPropertyDescs( default, null ) : Array<EntityComponentDescription> = [];

	// character
	public var dynamics( default, null ) : Null<DynamicsDescription>;
	public var rigidBodyTorsoDesc( default, null ) : Null<RigidBodyTorsoDescription>;
	public var staticRigidBodyDecs( default, null ) : Null<StaticObjectRigidBodyDescription>;
	public var bodyHitbox( default, null ) : Null<HitboxBodyDescription>;
	public var attackDesc( default, null ) : Null<AttackListDescription>;
	public var ai( default, null ) : Null<EntityAIDescription>;
	public var model : Null<EntityModelDescription>;

	// structure
	public var interactabeDesc( default, null ) : Null<InteractableDescription>;

	// item
	public var ofItem : EntityOfItemComponentDescription;

	#if client
	public var view : Null<EntityViewDescription>;
	public var lightSource : Null<EntityLightSourceDescription>;
	#end

	public function new( entry : Data.EntityPreset ) {
		super( entry.id.toString() );

		createPropDescriptions( entry );

		for ( propertyDesc in propertyDescs ) {
			map[propertyDesc.id] = propertyDesc;
		}
	}

	public inline function getComponentDescription( id : String ) {
		return map[id];
	}

	function createPropDescriptions( entry : Data.EntityPreset ) {
		propertyDescs = ArrayExtensions.deNullify(( [

			entry.properties.properties.dynamics ? dynamics = new DynamicsDescription( entry.id + "Dynamics" ) : null,

			// character
			rigidBodyTorsoDesc = RigidBodyTorsoDescription.fromCdb( entry.properties.properties.rigidBodyTorso ),
			staticRigidBodyDecs = StaticObjectRigidBodyDescription.fromCdb( entry.properties.properties.staticObjectRigidBody ),
			bodyHitbox = HitboxBodyDescription.fromCdb( entry.properties.properties.bodyHitbox ),
			attackDesc = AttackListDescription.fromCdb( entry.properties.properties.attack ),
			model = EntityModelDescription.fromCdb( entry.properties.properties.model ),
			ai = EntityAIDescription.fromCdb( entry.properties.properties.behaviour ),

			// structure
			interactabeDesc = InteractableDescription.fromCdb( entry.properties.properties.interactable ),

			// item
			ofItem = new EntityOfItemComponentDescription(),
			
		] : Array<EntityComponentDescription> ) );

		#if client
		clientPropertyDescs = ArrayExtensions.deNullify(( [
			view = EntityViewDescriptionAbstractFactory.fromCdb( entry.view ),
			lightSource = EntityLightSourceDescription.fromCdb( entry.properties.properties.lightSource ),
		] : Array<EntityComponentDescription> )
			.concat(
				EntityViewComponentExtensionsFactory.fromCdb( entry.view.viewComps )
			) );
		#end
	}
}
