package game.data.storage.entity.body.view;

import game.net.entity.component.view.EntityViewComponentReplicator;
import game.client.en.comp.view.EntityViewComponent;
import game.net.entity.EntityComponentReplicatorBase;
import net.NetNode;
import game.core.rules.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityViewDescription extends EntityComponentDescription {

	public final viewProvider : IEntityViewProvider;

	public function new( viewProvider : IEntityViewProvider, id ) {
		super( id );

		this.viewProvider = viewProvider;
	}

	public function buildComponennt() : EntityComponent {
		return new EntityViewComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		return new EntityViewComponentReplicator( parent );
	}
}
