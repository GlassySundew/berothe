package game.data.storage.entity.body;

import util.extensions.ArrayExtensions;
import game.data.storage.DescriptionBase;
import game.data.storage.entity.body.properties.DynamicsDescription;
import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.entity.body.properties.StaticObjectRigidBodyDescription;
import game.data.storage.entity.component.EntityComponentDescription;
#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
import haxe.macro.ExprTools;
import haxe.macro.TypeTools;
import haxe.macro.Type;
#end

class EntityBodyDescription extends DescriptionBase {

	public var propertyDescriptions( default, null ) : Array<EntityComponentDescription> = [];

	public var rigidBodyTorsoDesc( default, null ) : Null<RigidBodyTorsoDescription>;
	public var bodyHitbox( default, null ) : Null<HitboxBodyDescription>;
	public var dynamics( default, null ) : Null<DynamicsDescription>;
	public var staticRigidBodyDecs( default, null ) : Null<StaticObjectRigidBodyDescription>;

	public function new( entry : Data.EntityBody ) {
		super( entry.id.toString() );

		createComponents( entry );

		for ( propertyDesc in propertyDescriptions ) {
			DataStorage.inst.entityPropertiesStorage.provideExistingDescription( propertyDesc );
		}
	}

	function createComponents( entry : Data.EntityBody ) {
		propertyDescriptions = ArrayExtensions.deNullify(( [

			rigidBodyTorsoDesc = RigidBodyTorsoDescription.fromCdb( entry.properties.rigidBodyTorso ),
			bodyHitbox = HitboxBodyDescription.fromCdb( entry.properties.bodyHitbox ),
			staticRigidBodyDecs = StaticObjectRigidBodyDescription.fromCdb( entry.properties.staticObjectRigidBody ),

			entry.properties.dynamics ? dynamics = new DynamicsDescription() : null,

		] : Array<EntityComponentDescription> ) );
	}
}
