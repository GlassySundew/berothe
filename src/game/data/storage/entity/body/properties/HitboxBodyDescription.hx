package game.data.storage.entity.body.properties;

import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.core.rules.overworld.entity.EntityComponent;

class HitboxBodyDescription extends VolumetricBodyDescriptionBase {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_bodyHitbox
	) : HitboxBodyDescription {
		if ( entry == null ) return null;
		return new HitboxBodyDescription(
			0,
			0,
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

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		return null;
	}
}
