package game.net.entity.component;

import game.domain.overworld.entity.component.EntityPickableComponent;
#if client
import ui.tooltip.text.TextTooltipMediator;
import ui.InteractorFactory;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.net.entity.EntityComponentReplicatorBase;
#end

class EntityPickableComponentReplicator extends EntityComponentReplicatorBase {

	var pickableComponenent : EntityPickableComponent;

	public function new( parent ) {
		super( parent );
	}

	@:rpc
	function pickupBy( entity : EntityReplicator ) {}

	#if client
	override function followComponentClient( entity : OverworldEntity ) {
		super.followComponentClient( entity );

		followedComponent.then( ( component ) -> {
			pickableComponenent = Std.downcast( component, EntityPickableComponent );

			entity.components.onAppear(
				EntityViewComponent,
				( _, viewComp ) -> createInteractor( viewComp )
			);
		} );
	}

	function createInteractor( viewComp : EntityViewComponent ) {

		var interactorVO = new InteractorVO();
		interactorVO.doHighlight = true;
		interactorVO.highlightColor = 0xF2F2F2;
		interactorVO.tooltipVO = new TextTooltipMediator(
			pickableComponenent.pickableDesc.tooltipLocale
		);

		viewComp.view.then( ( view ) -> {
			var int = InteractorFactory.create(
				interactorVO,
				view.getGraphics()
			);

			int.onClick.add( ( e ) -> {
			} );
		} );
	}
	#end
}
