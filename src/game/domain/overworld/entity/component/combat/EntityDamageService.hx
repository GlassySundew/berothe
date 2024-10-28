package game.domain.overworld.entity.component.combat;

import game.client.en.comp.view.EntityViewComponent;
import game.data.storage.entity.body.properties.AttackListItemVO;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.data.storage.entity.body.properties.AttackListDescription;

class EntityDamageService {

	public static function entityDamageWithAttackListItem(
		sourceEntity : OverworldEntity,
		targetEntity : OverworldEntity,
		sourceAttackListItem : AttackListItemVO
	) {
		var equipType = sourceAttackListItem.equipSlotType;
		var sourceModel = sourceEntity.components.get( EntityModelComponent );
		var targetModel = targetEntity.components.get( EntityModelComponent );
		// todo weapon archetype consideration
		var itemEquipped = sourceModel.inventory.equipSlots[equipType].itemProp.getValue();

		var attackStat = sourceModel.stats.limbAttacks.filter( limbAttk -> limbAttk.limb == equipType )[0];
		attackStat.amount;

		targetModel.getDamagedWith( 1, PHYSICAL );
	}
}
