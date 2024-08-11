package game.data.storage.entity.body.auxil;

import game.net.entity.component.EntitySimpleComponentReplicator;
import game.client.en.comp.auxil.EntityMountPointsComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.core.rules.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityMountPointsDescription extends EntityComponentDescription {

	public static inline function getIdFromEntity( bodyDesc : Data.EntityPreset ) : String {
		return bodyDesc.id + "MountPoint";
	}

	public function buildComponennt() : EntityComponent {
		return new EntityMountPointsComponent();
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		return new EntitySimpleComponentReplicator( parent );
	}
}
