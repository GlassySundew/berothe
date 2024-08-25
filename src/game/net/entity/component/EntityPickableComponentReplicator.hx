package game.net.entity.component;

import ui.InteractorFactory;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.net.entity.EntityComponentReplicatorBase;

class EntityPickableComponentReplicator extends EntityComponentReplicatorBase {

	public function new(parent) {
		super(parent);
	}

	override function followComponentClient( entity : OverworldEntity ) {
		super.followComponentClient( entity );

		entity.components.onAppear(
			EntityViewComponent,
			( _, viewComp ) -> createInteractor( viewComp )
		);
	}

	function createInteractor( viewComp : EntityViewComponent ) {
		var interactorConfig = new InteractorVO();

		InteractorFactory.create( interactorConfig, viewComp.view.getGraphics() );
	}
}
