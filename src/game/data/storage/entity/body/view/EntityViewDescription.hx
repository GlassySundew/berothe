package game.data.storage.entity.body.view;

import net.NetNode;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.EntityComponentReplicatorBase;
import game.net.entity.component.view.EntityViewComponentReplicator;

class EntityViewDescription extends EntityComponentDescription {

	public final viewProvider : IEntityViewProvider;

	public function new( viewProvider : IEntityViewProvider, id ) {
		super( id );
		this.viewProvider = viewProvider;
	}

	public function buildComponent() : EntityComponent {
		return new EntityViewComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		return new EntityViewComponentReplicator( parent );
	}
}
