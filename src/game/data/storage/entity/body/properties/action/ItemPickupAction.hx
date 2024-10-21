package game.data.storage.entity.body.properties.action;

import game.domain.overworld.GameCore;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.entity.OverworldEntity;

class ItemPickupAction extends BodyActionBase {

	final itemDescId : String;

	public function new( itemDescId : String ) {
		this.itemDescId = itemDescId;
	}

	public function perform(
		self : OverworldEntity,
		user : OverworldEntity
	) {
		var itemDesc = DataStorage.inst.itemStorage.getById( itemDescId );
		var model = user.components.get( EntityModelComponent );
		var hasSpace = model.hasSpaceForItemDesc( itemDesc, 1 );
		if ( !hasSpace ) return;

		var item = GameCore.inst.itemFactory.createItem( itemDesc );

		model.tryPickupItem( item );
		self.dispose();
	}
}
