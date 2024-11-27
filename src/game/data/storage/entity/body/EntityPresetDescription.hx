package game.data.storage.entity.body;

import game.data.storage.entity.body.properties.EntityFlyingDescription;
import game.data.storage.entity.body.properties.LocalDispatchPointDescription;
import game.data.storage.entity.body.properties.DeathMessageDescription;
import util.extensions.ArrayExtensions;
import game.data.storage.DescriptionBase;
import game.data.storage.entity.body.model.EntityModelDescription;
import game.data.storage.entity.body.properties.AttackListDescription;
import game.data.storage.entity.body.properties.DynamicsDescription;
import game.data.storage.entity.body.properties.EntityAIDescription;
import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.data.storage.entity.body.properties.InteractableDescription;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.entity.body.properties.StaticObjectRigidBodyDescription;
import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.body.view.extensions.ViewColorRandomShiftDescription;
import game.data.storage.entity.body.view.extensions.ViewStencilDescription;
import game.data.storage.entity.component.EntityComponentDescription;
import game.data.storage.item.EntityOfItemComponentDescription;
#if client
import game.data.storage.entity.body.view.EntityLightSourceDescription;
import game.data.storage.entity.body.view.EntityViewDescriptionAbstractFactory;
#end

class EntityPresetDescription extends DescriptionBase {

	public final map : Map<String, EntityComponentDescription> = [];

	public var propertyDescs( default, null ) : Array<EntityComponentDescription> = [];
	public var clientPropertyDescs( default, null ) : Array<EntityComponentDescription> = [];

	// special
	public var deathMessage : DeathMessageDescription;

	// character
	public var dynamics( default, null ) : Null<DynamicsDescription>;
	public var canChangeLocation( default, null ) : Bool;
	public var isAnchor( default, null ) : Bool;
	public var rigidBodyTorsoDesc( default, null ) : Null<RigidBodyTorsoDescription>;
	public var staticRigidBodyDesc( default, null ) : Null<StaticObjectRigidBodyDescription>;
	public var bodyHitbox( default, null ) : Null<HitboxBodyDescription>;
	public var attackDesc( default, null ) : Null<AttackListDescription>;
	public var ai( default, null ) : Null<EntityAIDescription>;
	public var model : Null<EntityModelDescription>;
	public var fly : Null<EntityFlyingDescription>;

	// structure
	public var interactabeDesc( default, null ) : Null<InteractableDescription>;
	public var localDispatchPoint( default, null ) : Null<LocalDispatchPointDescription>;

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
		canChangeLocation = entry.properties.properties.canChangeLocation;
		isAnchor = entry.properties.properties.isAnchor;

		propertyDescs = ArrayExtensions.deNullify(( [

			entry.properties.properties.dynamics ? dynamics = new DynamicsDescription( entry.id + "Dynamics" ) : null,

			// special
			deathMessage = new DeathMessageDescription(),

			// character
			rigidBodyTorsoDesc = RigidBodyTorsoDescription.fromCdb( entry.properties.properties.rigidBodyTorso ),
			staticRigidBodyDesc = StaticObjectRigidBodyDescription.fromCdb( entry.properties.properties.staticObjectRigidBody ),
			bodyHitbox = HitboxBodyDescription.fromCdb( entry.properties.properties.bodyHitbox ),
			attackDesc = AttackListDescription.fromCdb( entry.properties.properties.attack ),
			model = EntityModelDescription.fromCdb( entry.properties.properties.model ),
			ai = EntityAIDescription.fromCdb( entry.properties.properties.behaviour ),
			fly = EntityFlyingDescription.fromCdb( entry.properties.properties.flyingDistance ),

			// structure
			interactabeDesc = InteractableDescription.fromCdb( entry.properties.properties.interactable ),
			localDispatchPoint = LocalDispatchPointDescription.fromCdb( entry.properties.properties.localDispatchPoint ),

			// item
			ofItem = new EntityOfItemComponentDescription(),

		] : Array<EntityComponentDescription> ) );

		#if client
		clientPropertyDescs = ArrayExtensions.deNullify(( [
			view = EntityViewDescriptionAbstractFactory.fromCdb( entry.view ),
			lightSource = EntityLightSourceDescription.fromCdb( entry.properties.properties.lightSource ),
			ViewColorRandomShiftDescription.fromCdb( entry.view.viewComps.colorRandomShift ),
			ViewStencilDescription.fromCdb( entry.view.viewComps.stencil ),

		] : Array<EntityComponentDescription> ) );
		#end
	}
}
