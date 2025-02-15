package game.client.en.comp.view.ui;

import h2d.Object;
import rx.disposables.Composite;
import rx.disposables.ISubscription;
import game.domain.overworld.item.model.ItemSlot;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.domain.overworld.entity.OverworldEntity;
import signals.Signal;
import game.domain.overworld.entity.component.model.EntityStats;
import game.data.storage.entity.model.EntityEquipmentSlotType;

class EntityStatsHudMediator {

	public final onAttackChanged = new Signal<String>();
	public final onDefenceChanged = new Signal<String>();
	public final onGoldChanged = new Signal<String>();

	final view : EntityStatsHudViewMediator;
	final stats : EntityStats;
	final entity : OverworldEntity;
	final model : EntityModelComponent;

	var attackListComp : EntityAttackListComponent;
	var leadingAttackEquip : EntityEquipmentSlotType;

	final subscribtion = Composite.create();

	public function new(
		model : EntityModelComponent,
		entity : OverworldEntity,
		parent : Object
	) {
		this.stats = model.stats;
		this.entity = entity;
		this.model = model;

		view = new EntityStatsHudViewMediator( this, parent );

		entity.components.onAppear(
			EntityAttackListComponent,
			( _, attackListComp ) -> {
				this.attackListComp = attackListComp;
				leadingAttackEquip = attackListComp.leadingAttack;
			}
		);

		subscribe();
	}

	public function dispose() {
		onAttackChanged.destroy();
		onDefenceChanged.destroy();
		onGoldChanged.destroy();
		subscribtion.unsubscribe();
		view.comp.remove();
	}

	function subscribe() {
		subscribeAttack();
		subscribeDefence();
		subscribeGold();
	}

	function subscribeAttack() {
		for ( limbAttack in stats.limbAttacks ) {
			limbAttack.amount.addOnValueImmediately( handler_onAttackChanged );
		}
	}

	function subscribeDefence() {
		stats.defence.amount.addOnValueImmediately( handler_onDefenceChanged );
	}

	function subscribeGold() {
		var goldSlot = model.inventory.inventorySlots.filter(
			( slot ) -> slot.restriction.types.contains( GOLD )
		)[0];
		var sub : Composite = null;
		subscribtion.add( goldSlot.itemProp.addOnValueImmediately( ( oldItem, newItem ) -> {
			sub?.unsubscribe();
			sub = Composite.create();
			if ( newItem == null ) {
				handler_onGoldChanged( goldSlot, 0, 0 );
			} else {
				sub.add( newItem.amount.addOnValueImmediately( handler_onGoldChanged.bind( goldSlot ) ) );
			}
		} ) );
	}

	function handler_onAttackChanged( _, _ ) {
		var result = "Attack:";

		for ( attackListItem in attackListComp.attacksList ) {
			result += " ";
			var equipSlotType = attackListItem.desc.equipSlotType;
			var limbAttack = stats.limbAttacks.filter(
				limbAttack -> limbAttack.desc.equipSlotType == equipSlotType
			)[0];
			switch equipSlotType {
				case
					EQUIP_HAND_LEFT
					| EQUIP_HAND_RIGHT:
					var isLeading = equipSlotType == leadingAttackEquip;
					if ( !isLeading ) result += "(";
					result += limbAttack.amount.getValue();
					if ( !isLeading ) result += ")";
				default:
					result += '[${limbAttack.amount.getValue()}]';
			}
		}

		onAttackChanged.dispatch( result );
	}

	function handler_onDefenceChanged( _, _ ) {
		var result = "Defence:" + " ";
		result += Std.int( stats.defence.amount.getValue() );
		onDefenceChanged.dispatch( result );
	}

	function handler_onGoldChanged( goldSlot : ItemSlot, _, _ ) {
		var result = "Gold:" + " ";
		var item = goldSlot.itemProp.getValue();
		result += item != null ? item.amount.getValue() : 0;

		onGoldChanged.dispatch( result );
	}
}
