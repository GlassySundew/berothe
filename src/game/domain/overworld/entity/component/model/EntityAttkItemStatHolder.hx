package game.domain.overworld.entity.component.model;

import Types.Number;
import game.data.storage.entity.body.properties.AttackListItemVO;
import game.data.storage.entity.model.EntityEquipmentSlotType;

class EntityAttkItemStatHolder extends EntityStatHolder {

	public final desc : AttackListItemVO;

	public function new( desc : AttackListItemVO ) {
		super();
		this.desc = desc;
	}
}
