package game.domain.overworld.item.model;

import game.domain.overworld.entity.EntityComponent;

class EntityOfItemComponent extends EntityComponent {

	public var item : Item;

	public function provideItem( item : Item ) {
		if ( this.item != null ) throw "item entity already has item: " + this.item;
		this.item = item;
	}
}
