package game.net.entity.component;

import game.domain.overworld.entity.component.EntityDynamicsComponent;
import ui.InteractorFactory;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.net.entity.EntityComponentReplicatorBase;

class EntityPickableComponentReplicator extends EntityComponentReplicatorBase {

	public function new( parent ) {
		super( parent );
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
		interactorConfig.doHighlight = true;
		interactorConfig.highlightColor = 0x6d0303;
		
		viewComp.view.then( ( view ) -> {
			InteractorFactory.create(
				interactorConfig,
				view.getGraphics()
			);
		} );
	}
}
