package game.data.storage.entity.body.properties;

import net.NetNode;
import game.net.entity.EntityComponentReplicator;
import game.core.rules.overworld.entity.EntityComponent;

class HitboxBodyDescription extends VolumetricBodyDescriptionBase {

	public static function fromCdb(
		entry : Data.EntityBody_properties_bodyHitbox
	) : HitboxBodyDescription {
		if ( entry == null ) return null;
		return new HitboxBodyDescription(
			entry.offsetZ,
			entry.sizeX,
			entry.sizeY,
			entry.sizeZ,
			entry.id.toString()
		);
	}

	public function buildComponennt() : EntityComponent {
		return null;
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicator {
		return null;
	}
}
