package game.data.storage.entity.body.view;

import game.data.storage.entity.component.EntityComponentDescription;

class EntityViewDescription extends EntityComponentDescription {

	public final viewProvider : IEntityViewProvider;

	public function new( viewProvider : IEntityViewProvider, id ) {
		super( id );
		this.viewProvider = viewProvider;
	}
}
