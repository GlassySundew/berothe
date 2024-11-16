package game.domain.overworld.entity.component.model;

import game.domain.overworld.item.model.ItemRestriction;
import util.MathUtil;
import game.data.storage.DataStorage;
import hxd.Rand;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.item.model.EquipItemSlot;
import game.data.storage.entity.body.model.EntityEquipSlotDescription;
import game.domain.overworld.item.model.IItemContainer;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;

class EntityInventory extends EntityItemHolderBase {

	public final equipSlots : Map<EntityEquipmentSlotType, EquipItemSlot> = [];

	public var inventorySlots( default, null ) : Array<ItemSlot>;

	final baseInventorySize : Int;
	final equipSlotsDesc : Array<EntityEquipSlotDescription>;

	public function new(
		model : EntityModelComponent,
		baseInventorySize : Int,
		equipSlotsDesc : Array<EntityEquipSlotDescription>
	) {
		this.equipSlotsDesc = equipSlotsDesc;
		this.baseInventorySize = baseInventorySize;

		createSlots();

		super( model );
	}

	public function claimOwnage() {
		// todo она должна знать что сущность не загружается, а создаётся с нуля. для spawnInventory
		addItemsOnEntityCreation();
		model.onDeath.then( _ -> dropInventory() );
	}

	inline function addItemsOnEntityCreation() {
		for ( elem in model.desc.spawnInventory ) {
			var itemDesc = DataStorage.inst.itemStorage.getById( elem.itemDescId );
			var amount = //
				if ( elem.botEdgeRnd == elem.topEdgeRnd ) {
					elem.botEdgeRnd;
				} else {
					switch elem.distribution {
						case LINEAR:
							Random.int( elem.botEdgeRnd, elem.topEdgeRnd );
						case SKEW( power ):
							Std.int(
								MathUtil.randomSkew( elem.botEdgeRnd, elem.topEdgeRnd, power )
							);
					};
				}
			var item = GameCore.inst.itemFactory.createItem( itemDesc );
			item.amount.val = amount;
			tryGiveItem( item );
		}
	}
	var goldSlot : ItemSlot;
	function createSlots() {
		inventorySlots = [];

		goldSlot = new ItemSlot( 99, new ItemRestriction( [GOLD] ) );
		inventorySlots.push( goldSlot );

		for ( equipSlotDesc in equipSlotsDesc ) {
			var slot = new EquipItemSlot( equipSlotDesc );
			slot.itemProp.addOnValue( onItemChangedInSlot.bind( _, _, slot ) );
			equipSlots[equipSlotDesc.type] = slot;

			inventorySlots.push( slot );
		}

		for ( i in 0...baseInventorySize ) {
			inventorySlots.push( new ItemSlot() );
		}
	}

	function getItemSlotIterator() : Iterator<ItemSlot> {
		return inventorySlots.iterator();
	}

	// todo use it for regular as well when items that lie in inventory start giving stats
	function onItemChangedInSlot( oldItem : Item, newItem : Item, ?slot : EquipItemSlot ) {
		// removeStats( oldItem?.stats, slot );

		if ( newItem != null && newItem.stats.length > 0 ) {
			model.stats.addStats( newItem.stats, slot );
		}
	}
}
