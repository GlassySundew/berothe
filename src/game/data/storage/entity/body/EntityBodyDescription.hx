package game.data.storage.entity.body;

import game.data.storage.entity.component.EntityComponentDescription;
import util.Extensions.ArrayExtensions;
import game.data.storage.entity.body.properties.DynamicsDescription;
import game.data.storage.DescriptionBase;
import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;

class EntityBodyDescription extends DescriptionBase {

	public final propertyDescriptions : Array<EntityComponentDescription> = [];

	public var rigidBodyTorsoDesc( default, null ) : Null<RigidBodyTorsoDescription>;
	public var bodyHitbox( default, null ) : Null<HitboxBodyDescription>;
	public var dynamics( default, null ) : Null<DynamicsDescription>;

	public function new( entry : Data.EntityBody ) {
		super( entry.id.toString() );

		createComponents( entry );

		propertyDescriptions = ArrayExtensions.deNullify(( [
			rigidBodyTorsoDesc,
			bodyHitbox,
			dynamics
		] : Array<EntityComponentDescription> ) );
	}

	function createComponents( entry : Data.EntityBody ) {

		if ( entry.properties.rigidBodyTorso != null ) {
			var cdbProp = entry.properties.rigidBodyTorso;
			rigidBodyTorsoDesc = new RigidBodyTorsoDescription(
				cdbProp.offsetZ,
				cdbProp.sizeX,
				cdbProp.sizeY,
				cdbProp.sizeZ
			);
		}

		if ( entry.properties.bodyHitbox != null ) {
			var cdbProp = entry.properties.bodyHitbox;
			bodyHitbox = new HitboxBodyDescription(
				cdbProp.offsetZ,
				cdbProp.sizeX,
				cdbProp.sizeY,
				cdbProp.sizeZ
			);
		}

		if ( entry.properties.dynamics ) {
			dynamics = new DynamicsDescription();
		}
	}
}
