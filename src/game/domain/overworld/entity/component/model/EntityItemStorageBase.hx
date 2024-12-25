package game.domain.overworld.entity.component.model;

import game.net.server.GameServer;
import game.domain.overworld.item.model.EntityOfItemComponent;
import game.domain.overworld.item.model.ItemSlot;
import game.data.storage.item.ItemDescription;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.item.Item;
import game.domain.overworld.item.model.ItemSlot;

abstract class EntityItemStorageBase {

	public static final FRONT_DROPPING_DISTANCE = 5;

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
		for ( slot in slots ) {
			if ( slot.hasSpaceForItem( item.desc, item.amount ) ) {
				slot.giveItem( item );
				if (
					item.itemContainerProp.getValue() == slot
					|| item.amount.getValue() == 0
				) return ItemPickupAttemptResult.success();
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
		for ( slot in slots ) {
			var item = slot.itemProp.getValue();
			if ( item == null ) continue;
			dropItemAround( item );
			slot.removeItem();
		}
	}

	/**
		usually used when dropping manually
	**/
	public function dropItemInFront( item : Item ) {
		var halfSizes = getHalfSizes();

		inline function setPosition( entity : OverworldEntity ) {
			entity.transform.setPosition(
				model.entity.transform.x.val + FRONT_DROPPING_DISTANCE * Math.cos( model.entity.transform.rotationZ ),
				model.entity.transform.y.val + FRONT_DROPPING_DISTANCE * Math.sin( model.entity.transform.rotationZ ),
				model.entity.transform.z.val + halfSizes.sizeHalfZ
			);
		}
		var entityItem = createEntityForItem( item );
		setPosition( entityItem );
	}

	/**
		usually used when dropping upon death, or gold dropping
	**/
	public function dropItemAround( item : Item ) {
		var halfSizes = getHalfSizes();

		inline function setPosition( entity : OverworldEntity ) {
			entity.transform.setPosition(
				model.entity.transform.x.val + Random.int(-halfSizes.sizeHalfX, halfSizes.sizeHalfX ),
				model.entity.transform.y.val + Random.int(-halfSizes.sizeHalfY, halfSizes.sizeHalfY ),
				model.entity.transform.z.val + Random.int( 0, halfSizes.sizeHalfZ )
			);
		}

		var entity = null;
		if ( item.amount.val > 1 && item.desc.isSplittable ) {
			for ( splittedItem in GameCore.inst.itemFactory.split( item ) ) {
				entity = createEntityForItem( splittedItem );
				setPosition( entity );
			}
		} else {
			entity = createEntityForItem( item );
			setPosition( entity );
		}
	}

	inline function createEntityForItem( item : Item ) {
		var entityItem = GameCore.inst.entityFactory.createEntity(
			item.desc.getOverworldReprEntityDesc()
		);

		entityItem.components.get( EntityOfItemComponent ).provideItem( item );
		model.entity.location.getValue().addEntity( entityItem );

		return entityItem;
	}

	inline function getHalfSizes() {
		var torsoDesc = model.entity.desc.getBodyDescription().rigidBodyTorsoDesc;
		var sizeHalfZ = Std.int( torsoDesc.sizeZ + torsoDesc.offsetZ ) >> 1;
		var sizeHalfY = Std.int( torsoDesc.sizeY ) >> 1;
		var sizeHalfX = Std.int( torsoDesc.sizeX ) >> 1;

		return {
			sizeHalfZ : sizeHalfZ,
			sizeHalfY : sizeHalfY,
			sizeHalfX : sizeHalfX,
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
