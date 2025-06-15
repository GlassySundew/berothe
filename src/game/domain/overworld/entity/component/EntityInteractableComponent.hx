package game.domain.overworld.entity.component;

import future.Future;
#if client
import graphics.ThrEventInteractive;
import rx.disposables.Composite;
import signals.Signal;
import ui.InteractorFactory.InteractorVO;
import ui.InteractorFactory;
import ui.tooltip.text.TextTooltipMediator;
import game.client.en.comp.view.EntityViewComponent;
import game.net.client.GameClient;
#end
import core.IProperty;
import core.MutableProperty;
import util.BoolList;
import util.MathUtil;
import game.data.storage.DataStorage;
import game.data.storage.entity.body.properties.InteractableDescription;
import game.data.storage.entity.body.properties.action.BodyActionBase;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.entity.component.model.Requirement;

class EntityInteractableComponent extends EntityComponent {

	public final desc : InteractableDescription;
	public final interactionBoolList = new BoolList<OverworldEntity>();

	final actions : Array<BodyActionBase>;
	final interactionReq : Requirement;

	public final isTurnedOn : MutableProperty<Bool> = new MutableProperty( true );
	#if client
	public final interactive : Future<ThrEventInteractive> = new Future();
	#end

	public function new( desc : InteractableDescription ) {
		super( desc );
		this.desc = desc;
		actions = desc.actionQueue.map( lazy -> lazy.get() );
		interactionReq = new Requirement();
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		interactionBoolList.addLambda( checkDistance );
		if ( desc.itemRequired != null ) {
			var itemDesc = DataStorage.inst.itemStorage.getById( desc.itemRequired.itemDescId );
			interactionReq.addItem( itemDesc );
		}

		#if client
		entity.components.onAppear(
			EntityViewComponent,
			( cl, viewComp ) -> createInteractor( viewComp )
		);
		#end
	}

	#if client
	function createInteractor( viewComp : EntityViewComponent ) {
		if ( !isTurnedOn.val ) return;

		var interactorVO = new InteractorVO();
		interactorVO.doHighlight = true;
		interactorVO.highlightColor = 0xD9D9D9;

		if ( desc.tooltipLocale != null )
			interactorVO.tooltipVO = new TextTooltipMediator(
				desc.tooltipLocale
			);

		// GameClient.inst.controlledEntity.onAppear( ctrlEnt -> {
		// 	ctrlEnt.entity.result.components.onAppear(
		// 		EntityDynamicsComponent,
		// 		( _, dynamics ) -> {

		// 			var sub = Composite.create();
		// 			var predicamentSignal = new Signal<Bool>();
		// 			sub.add( dynamics.onMove.add(() -> {
		// 				predicamentSignal.dispatch(
		// 					checkDistance(
		// 						ctrlEnt.entity.result
		// 					)
		// 				);
		// 			} ) );

		// 			viewComp.view.then( ( view ) -> {
		// 				var int = InteractorFactory.create(
		// 					interactorVO,
		// 					view.getGraphics(),
		// 					predicamentSignal
		// 				);

		// 				sub.add( isTurnedOn.addOnValueImmediately(
		// 					( old, newV ) -> {
		// 						if ( newV ) return;

		// 						predicamentSignal.destroy();
		// 						sub.unsubscribe();

		// 						int.remove();
		// 					}
		// 				) );

		// 				interactive.resolve( int );
		// 			} );
		// 		}
		// 	);
		// } );
	}
	#end

	public function useBy( entity : OverworldEntity ) {
		var modelComp = entity.components.get( EntityModelComponent );

		if (
			!interactionBoolList.computeAnd( entity )
			|| !interactionReq.isFulfilled( modelComp ) //
		) {
			trace( "forbidding use from " + entity );
			return;
		}

		for ( action in actions ) {
			action.perform( this.entity, entity );
		}

		if ( desc.itemRequired == null ) return;
		if ( desc.itemRequired.breakChance > Math.random() ) {
			var itemDesc = DataStorage.inst.itemStorage.getById( desc.itemRequired.itemDescId );
			modelComp.inventory.removeItem( itemDesc, 1 );
		}
	}

	public function checkDistance( entityUser : OverworldEntity ) {
		var distTo = MathUtil.dist3(
			entityUser.transform.x.val,
			entityUser.transform.y.val,
			entityUser.transform.z.val,

			entity.transform.x.val,
			entity.transform.y.val,
			entity.transform.z.val,
		);
		return distTo < DataStorage.inst.rule.interactionRange;
	}
}
