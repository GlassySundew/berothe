package game.data.storage.entity.body.model;

import game.data.storage.entity.model.EntityEquipmentSlotType;

class EntityEquipSlotDescription {

	public final type : EntityEquipmentSlotType;
	public final priority : Int;

	public function new( type : EntityEquipmentSlotType, priority : Int ) {
		this.type = type;
		this.priority = priority;
	}
}
