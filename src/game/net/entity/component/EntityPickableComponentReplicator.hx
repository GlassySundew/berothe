package game.net.entity.component;

import hxbit.NetworkHost;
import game.data.storage.DataStorage;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.client.GameClient;
import game.domain.overworld.GameCore;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.component.EntityPickableComponent;
import game.domain.overworld.item.ItemFactory;
#if client
import ui.tooltip.text.TextTooltipMediator;
import ui.InteractorFactory;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.net.entity.EntityComponentReplicatorBase;
#end

class EntityPickableComponentReplicator extends EntityComponentReplicatorBase {

	var pickableComponent( get, never ) : EntityPickableComponent;
	inline function get_pickableComponent() {
		return Std.downcast( component, EntityPickableComponent );
	}

	public function new( parent ) {
		super( parent );
	}

	@:rpc( server )
	function pickupBy( entityReplId : String ) : Void {
		#if client throw "should not be called on client"; #end

		var entityRepl = CoreReplicator.inst.getEntityReplicatorById( entityReplId );
		pickableComponent.pickupBy( entityRepl.entity.result );

		this.entityRepl.__host = null;
	}

	override public function networkAllow(
		op : hxbit.NetworkSerializable.Operation,
		propId : Int,
		clientSer : hxbit.NetworkSerializable
	) : Bool {
		return true;
	}

	override function alive() {
		super.alive();
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
		interactorVO.tooltipVO = new TextTooltipMediator(
			pickableComponent.pickableDesc.tooltipLocale
		);

		viewComp.view.then( ( view ) -> {
			var int = InteractorFactory.create(
				interactorVO,
				view.getGraphics()
			);

			int.onClick.add( ( e ) -> {
				clickedByEntity( GameClient.inst.controlledEntity );
			} );
		} );
	}

	function clickedByEntity( entityRepl : EntityReplicator ) {
		var pickable = Std.downcast( component, EntityPickableComponent );
		var model = entityRepl.entity.result.components.get( EntityModelComponent );

		var hasSpace = model.hasSpaceForItemDesc( pickable.pickableDesc.getItemDescription(), 1 );
		if ( hasSpace ) {
			pickupBy( entityRepl.entity.result.id );
		} else {
			trace( "not enough space" );
		}
	}
	#end
}
