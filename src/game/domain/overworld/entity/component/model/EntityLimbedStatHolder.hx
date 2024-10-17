package game.domain.overworld.entity.component.model;

import game.data.storage.entity.model.EntityEquipmentSlotType;

class EntityLimbedStatHolder extends EntityStatHolder {

	public final limb : Null<EntityEquipmentSlotType>;
	
	public function new( ?limb : EntityEquipmentSlotType ) {
		super();
		this.limb = limb;
	}
}
