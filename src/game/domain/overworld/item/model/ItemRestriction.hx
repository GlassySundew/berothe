package game.domain.overworld.item.model;

import game.data.storage.item.ItemDescription;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import util.Util;
import game.data.storage.item.ItemType;

class ItemRestriction {

	public var isEquipment : Bool;
	public var equipmentType : EntityEquipmentSlotType;

	public final types : Array<ItemType>;

	public function new( ?types : Array<ItemType> ) {
		this.types = types ?? [];
	}

	public function isFulfilledByItem( itemDesc : ItemDescription ) : Bool {
		// if(type)
		var typesComparison = Util.isArrayCompletePartOfAnother( types, itemDesc.types );
		var equipFulfil = //
			!isEquipment || (
				itemDesc.equippable
				&& itemDesc.equipSlots.contains( equipmentType )
			);

		return
			typesComparison
			&& equipFulfil;
	}
}
