package game.client.en.comp.view.ui;

import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.domain.overworld.entity.OverworldEntity;
import signals.Signal;
import game.domain.overworld.entity.component.model.EntityStats;
import game.data.storage.entity.model.EntityEquipmentSlotType;

class EntityStatsHudMediator {

	public final onAttackChanged = new Signal<String>();

	final clip : EntityStatsHudViewMediator;
	final stats : EntityStats;
	final entity : OverworldEntity;

	var attackListComp : EntityAttackListComponent;
	var leadingAttackEquip : EntityEquipmentSlotType;

	public function new(
		stats : EntityStats,
		entity : OverworldEntity
	) {
		this.stats = stats;
		this.entity = entity;
		clip = new EntityStatsHudViewMediator( this, Main.inst.root );

		entity.components.onAppear(
			EntityAttackListComponent,
			( _, attackListComp ) -> subscribe( attackListComp )
		);
	}

	function subscribe( attackListComp : EntityAttackListComponent ) {
		this.attackListComp = attackListComp;
		leadingAttackEquip = attackListComp.leadingAttack;
		for ( limbAttack in stats.limbAttacks ) {
			limbAttack.amount.addOnValue( handler_onAttackChanged );
		}
		handler_onAttackChanged( 0, 0 );
	}

	function handler_onAttackChanged( _, _ ) {
		var result = "Attack:" + " ";

		for ( attackListItem in attackListComp.attackComponents ) {
			var equipSlotType = attackListItem.desc.equipSlotType;
			var limbAttack = stats.limbAttacks[equipSlotType];
			switch equipSlotType {
				case EQUIP_HAND_LEFT
					| EQUIP_HAND_RIGHT:

					var isLeading = equipSlotType == leadingAttackEquip;
					if ( !isLeading ) result += "(";
					result += limbAttack.amount.getValue();
					if ( !isLeading ) result += ")";
				default:
					result += '[${limbAttack.amount.getValue()}]';
			}
			result += " ";
		}

		onAttackChanged.dispatch( result );
	}
}
