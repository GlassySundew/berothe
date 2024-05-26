package game.data.storage.entity.body;

import game.data.storage.entity.body.properties.HitboxBodyDescription;
import game.data.storage.entity.body.properties.VolumetricBodyDescriptionBase;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.DescriptionBase;

class EntityBodyDescription extends DescriptionBase {

	var rigidBodyTorsoDesc : RigidBodyTorsoDescription;
	var bodyHitbox : HitboxBodyDescription;
	var isDynamicsPropEnabled : Bool = false;

	public function new( entry : Data.EntityBody ) {
		super( entry.id.toString() );

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

		isDynamicsPropEnabled = entry.properties.dynamics;
	}

	public function init() {}
}
