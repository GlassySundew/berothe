package game.domain.overworld.entity.component.model;

import game.data.storage.entity.body.model.EntityModelDescription;
import core.MutableProperty;

class EntityModelComponent extends EntityComponent {

	public final hp : MutableProperty<Float> = new MutableProperty( 1. );
	public final inventory : EntityInventory = new EntityInventory();
	public final equip : EntityEquip = new EntityEquip();

	final desc : EntityModelDescription;

	public function new( desc : EntityModelDescription ) {
		super( desc );
		this.desc = desc;
	}

	
}
