package game.net.entity.component;

import ui.tooltip.text.TextTooltipVO;
#if client
import ui.InteractorFactory;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.net.entity.EntityComponentReplicatorBase;
#end

class EntityPickableComponentReplicator extends EntityComponentReplicatorBase {

	public function new( parent ) {
		super( parent );
	}

	#if client
	override function followComponentClient( entity : OverworldEntity ) {
		super.followComponentClient( entity );

		entity.components.onAppear(
			EntityViewComponent,
			( _, viewComp ) -> createInteractor( viewComp )
		);
	}

	function createInteractor( viewComp : EntityViewComponent ) {
		var interactorVO = new InteractorVO();
		interactorVO.doHighlight = true;
		interactorVO.highlightColor = 0xF2F2F2;
		interactorVO.tooltipVO = new TextTooltipVO( 'Poop' );

		viewComp.view.then( ( view ) -> {
			InteractorFactory.create(
				interactorVO,
				view.getGraphics()
			);
		} );
	}
	#end
}
