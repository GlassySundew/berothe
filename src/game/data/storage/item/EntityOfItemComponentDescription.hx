package game.data.storage.item;

import game.data.storage.entity.component.EntityComponentDescription;

class EntityOfItemComponentDescription extends EntityComponentDescription {

	public function new() {
		super( "ofItem" );
		isReplicable = false;
	}
}
