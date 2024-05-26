package en.structures.hydroponics;

import util.Util;
import en.spr.EntityView;

import hxd.Event;
import hxd.Key in K;
import util.Assets;

/** Использует inv как хранилище для растений **/
class Hydroponics extends Structure {

	public function new(  ) {
		super();
	}

	override function init() {
		// view = new EntityView(
		// 	this,
		// 	Assets.structures,
		// 	Util.hollowScene
		// );

		super.init();

		canBeInteractedWith.val = true;

		// inv.giveItem(new en.Item(axe));
		#if debug
		// cellGrid.giveItem(new en.Item(plant), this, true, false);
		// cellGrid.giveItem(new en.Item(plant), this, true, false);
		// cellGrid.giveItem(new en.Item(plant), this, true, false);
		#end

		interact.onTextInput = function ( e : Event ) {
			if ( K.isPressed( K.E ) ) dropGrownPlant();
		}
	}

	function dropGrownPlant() {
		// inv.grid[0][0].item = dropItem(inv.grid[0][0].item);
		if ( inventoryModel.inventory.itemCount > 0 ) {
			dropAllItems();
		}

		canBeInteractedWith.val = false;
	}

	override function update() {
		super.update();
	}
}
