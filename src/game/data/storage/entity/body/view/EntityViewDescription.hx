package game.data.storage.entity.body.view;

import game.net.entity.component.view.EntityViewComponentReplicator;
import game.core.rules.overworld.entity.component.view.EntityViewComponent;
import game.net.entity.EntityComponentReplicator;
import net.NetNode;
import game.core.rules.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityViewDescription extends EntityComponentDescription {

	public final viewProvider : IEntityView;

	public function new( viewProvider : IEntityView, id ) {
		super( id );

		this.viewProvider = viewProvider;
	}

	public function buildComponennt() : EntityComponent {
		return new EntityViewComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicator {
		return new EntityViewComponentReplicator( parent );
	}
}
