package game.domain.overworld.entity.component.model;

import game.domain.overworld.item.model.EntityOfItemComponent;
import game.domain.overworld.item.model.ItemSlot;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;

abstract class EntityItemHolderBase {

	/**
		слоты сервиса
	**/
	var slots : Array<ItemSlot>;
	final model : EntityModelComponent;

	public function new( model : EntityModelComponent ) {
		updateSlots();
		this.model = model;
	}

	#if !debug inline #end
	public function hasItem( desc : ItemDescription, amount = 1 ) {
		var result = false;
		for ( slot in slots ) {
			var item = slot.itemProp.getValue();
			if (
				item != null
				&& item.desc == desc
				&& item.amount.val >= amount
			) {
				result = true;
				break;
			}
		}
		return result;
	}

	public function tryGiveItem( item : Item ) {
		for ( equipSlot in slots ) {
			if ( equipSlot.hasSpaceForItem( item.desc, item.amount ) ) {
				equipSlot.giveItem( item );
				return ItemPickupAttemptResult.success();
			}
		}
		return ItemPickupAttemptResult.failure();
	}

	#if !debug inline #end
	public function removeItem( itemDesc : ItemDescription, amount = 1 ) : Int {
		var amountLeftToRemove = amount;
		for ( slot in slots ) {
			var item = slot.itemProp.getValue();
			if ( item == null || item.desc != itemDesc ) continue;

			if ( item.amount.val >= amountLeftToRemove ) {
				item.amount.val -= amountLeftToRemove;
				amountLeftToRemove = 0;
				break;
			} else {
				amountLeftToRemove -= item.amount.val;
				item.amount.val = 0;
			}
		}
		return amountLeftToRemove;
	}

	public function hasSpaceForItem( item : ItemDescription, amount = 1 ) : Bool {
		for ( equipSlot in slots ) {
			if ( equipSlot.hasSpaceForItem( item, amount ) ) {
				return true;
			}
		}
		return false;
	}

	public function dropInventory() {
		var torsoDesc = model.entity.desc.getBodyDescription().rigidBodyTorsoDesc;
		var sizeZ = Std.int( torsoDesc.sizeZ + torsoDesc.offsetZ / 2 );
		var sizeHLFY = Std.int( torsoDesc.sizeY / 2 );
		var sizeHLFX = Std.int( torsoDesc.sizeX / 2 );

		for ( slot in slots ) {
			var item = slot.itemProp.getValue();
			if ( item == null ) continue;

			inline function createEntityForItem( item : Item ) {
				var entityItem = GameCore.inst.entityFactory.createEntity(
					item.desc.getOverworldReprEntityDesc()
				);

				entityItem.components.get( EntityOfItemComponent ).provideItem( item );
				entityItem.transform.setPosition(
					model.entity.transform.x.val + Random.int(-sizeHLFX, sizeHLFX ),
					model.entity.transform.y.val + Random.int(-sizeHLFY, sizeHLFY ),
					model.entity.transform.z.val + Random.int( 0, sizeZ )
				);
				model.entity.location.getValue().addEntity( entityItem );
			}
			if ( item.amount.val > 1 && item.desc.isSplittable ) {
				for ( splittedItem in GameCore.inst.itemFactory.split( item ) ) {
					createEntityForItem( splittedItem );
				}
			} else {
				createEntityForItem( item );
			}
		}
	}

	function updateSlots() {
		slots = [];
		for ( i in getItemSlotIterator() ) {
			slots.push( i );
		}
		slots.sort( ( slot1, slot2 ) -> slot2.priority - slot1.priority );
	}

	abstract function getItemSlotIterator() : Iterator<ItemSlot>;
}
