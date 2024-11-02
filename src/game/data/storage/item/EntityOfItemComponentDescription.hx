package game.data.storage.item;

import game.domain.overworld.item.model.EntityOfItemComponent;
import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.data.storage.entity.component.EntityComponentDescription;
import game.domain.overworld.entity.EntityComponent;

class EntityOfItemComponentDescription extends EntityComponentDescription {

	public function new() {
		super( "ofItem" );
		isReplicable = false;
	}

	public function buildComponent() : EntityComponent {
		return new EntityOfItemComponent( this );
	}

	public function buildCompReplicator(
		?parent : NetNode
	) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
