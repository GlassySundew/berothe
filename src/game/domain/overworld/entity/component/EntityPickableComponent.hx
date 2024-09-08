package game.domain.overworld.entity.component;

import game.data.storage.item.EntityPickablePropertyDescription;

class EntityPickableComponent extends EntityComponent {

	public final pickableDesc : EntityPickablePropertyDescription;

	public function new( desc : EntityPickablePropertyDescription ) {
		this.pickableDesc = desc;

		super( desc );
	}
}
