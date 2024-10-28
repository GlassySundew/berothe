package game.data.storage.entity.body.properties;

import game.domain.overworld.entity.component.EntityHitboxComponent;
import game.net.entity.component.EntitySimpleComponentReplicator;
import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;

class HitboxBodyDescription extends VolumetricBodyDescriptionBase {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_bodyHitbox
	) : HitboxBodyDescription {
		if ( entry == null ) return null;
		return new HitboxBodyDescription(
			entry.offsetX,
			entry.offsetY,
			entry.offsetZ,
			entry.sizeX,
			entry.sizeY,
			entry.sizeZ,
			entry.id.toString()
		);
	}

	public function buildComponent() : EntityComponent {
		return new EntityHitboxComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		return new EntitySimpleComponentReplicator( parent );
	}
}
