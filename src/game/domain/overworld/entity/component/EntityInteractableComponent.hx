package game.domain.overworld.entity.component;

import game.domain.overworld.entity.component.model.Requirement;
import game.data.storage.DataStorage;
import util.MathUtil;
import util.BoolList;
import game.data.storage.entity.body.properties.action.BodyActionBase;
import core.IProperty;
import core.MutableProperty;
import game.data.storage.entity.body.properties.InteractableDescription;
import game.domain.overworld.entity.EntityComponent;

class EntityInteractableComponent extends EntityComponent {

	public final desc : InteractableDescription;
	public final interactionBoolList = new BoolList<OverworldEntity>();

	final actions : Array<BodyActionBase>;
	final interactionReq : Requirement;

	public final isTurnedOn : MutableProperty<Bool> = new MutableProperty( true );

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
			var itemDesc = DataStorage.inst.itemStorage.getDescriptionById( desc.itemRequired.itemDescId );
			interactionReq.addItem( itemDesc );
		}
	}

	public function useBy( entity : OverworldEntity ) {
		if ( !interactionBoolList.computeAnd( entity ) ) {
			trace( "forbidding use from " + entity );
			return;
		}

		for ( action in actions ) {
			action.perform( this.entity, entity );
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
