package game.domain.overworld.entity.component.model;

import game.data.storage.item.ItemDescription;

typedef ItemRequirement = {
	desc : ItemDescription,
	amount : Int
}

class Requirement {

	public final items : Array<ItemRequirement> = [];

	public function new() {}

	public function addItem( itemDesc : ItemDescription, amount : Int = 1 ) {
		for ( item in items ) {
			if ( item.desc == itemDesc ) {
				item.amount += amount;
				return;
			}
		}

		items.push( {
			desc : itemDesc,
			amount : amount
		} );
	}

	public function isFulfilled() {
		
	}
}
