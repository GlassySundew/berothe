package game.data.storage.entity.body.model;

import game.data.storage.entity.model.EntityEquipmentSlotType;

class EntityEquipSlotDescription {

	public final type : EntityEquipmentSlotType;
	public final priority : Int;
	public final links : Array<EntityEquipmentSlotType>;

	public function new(
		type : EntityEquipmentSlotType,
		priority : Int,
		links : Array<EntityEquipmentSlotType>
	) {
		this.type = type;
		this.priority = priority;
		this.links = links;
	}
}
