package game.net.entity.component;

#if client
import game.net.client.GameClient;
import ui.InteractorFactory;
import ui.tooltip.text.TextTooltipMediator;
import game.client.en.comp.view.EntityViewComponent;
import game.net.entity.EntityReplicator;
#end
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.component.EntityInteractableComponent;

class EntityInteractableReplicator extends EntityComponentReplicatorBase {

	var interactableComponent( get, never ) : EntityInteractableComponent;
	inline function get_interactableComponent() {
		return Std.downcast( component, EntityInteractableComponent );
	}

	override public function networkAllow(
		op : hxbit.NetworkSerializable.Operation,
		propId : Int,
		clientSer : hxbit.NetworkSerializable
	) : Bool {
		return true;
	}

	#if client
	override function followComponentClient( entityRepl : EntityReplicator ) {
		super.followComponentClient( entityRepl );

		followedComponent.then( ( component ) -> {
			entityRepl.entity.result.components.onAppear(
				EntityViewComponent,
				( _, viewComp ) -> createInteractor( viewComp )
			);
		} );
	}

	function createInteractor( viewComp : EntityViewComponent ) {
		var interactorVO = new InteractorVO();
		interactorVO.doHighlight = true;
		interactorVO.highlightColor = 0xD9D9D9;

		if ( interactableComponent.desc.tooltipLocale != null )
			interactorVO.tooltipVO = new TextTooltipMediator(
				interactableComponent.desc.tooltipLocale
			);

		viewComp.view.then( ( view ) -> {
			var int = InteractorFactory.create(
				interactorVO,
				view.getGraphics()
			);

			int.onClick.add( ( e ) -> {
				useBy( GameClient.inst.controlledEntity );
			} );
		} );
	}
	#end

	@:rpc( server )
	function useBy( entityRepl : EntityReplicator ) : Void {
		#if client throw "should not be called on client"; #end

		interactableComponent.useBy( entityRepl.entity.result );
	}
}
