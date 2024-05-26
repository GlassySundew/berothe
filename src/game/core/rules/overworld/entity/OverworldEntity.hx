package game.core.rules.overworld.entity;

import game.data.storage.entity.EntityDescription;
import game.core.rules.overworld.entity.component.EntityComponents;

class OverworldEntity {

	public final transform : EntityTransform = new EntityTransform();

	var entityComponents : EntityComponents = new EntityComponents();
	var entityDesc : EntityDescription;

	public function new( entityDesc : EntityDescription ) {
		this.entityDesc = entityDesc;
	}
}
