package game.domain.overworld.entity.component;

import util.BoolList;
import game.data.storage.entity.body.properties.action.BodyActionBase;
import core.IProperty;
import core.MutableProperty;
import game.data.storage.entity.body.properties.InteractableDescription;
import game.domain.overworld.entity.EntityComponent;

class EntityInteractableComponent extends EntityComponent {

	public final desc : InteractableDescription;
	public final interactionBoolList : BoolList = new BoolList();

	final actions : Array<BodyActionBase>;

	var canBeInteractedWith : Bool;

	final isInteractableProp : MutableProperty<Bool> = new MutableProperty( false );
	public var isInteractable( get, never ) : IProperty<Bool>;
	inline function get_isInteractable() {
		return isInteractableProp;
	}

	public function new( desc : InteractableDescription ) {
		super( desc );
		this.desc = desc;
		actions = desc.actionQueue.map( lazy -> lazy.get() );
		interactionBoolList.onListChanged.add(() -> {
			canBeInteractedWith = interactionBoolList.computeAnd();
		} );
	}

	public function useBy( entity : OverworldEntity ) {
		if ( !canBeInteractedWith ) {
			trace( "restricting interaction from " + entity );
			return;
		}

		for ( action in actions ) {
			action.perform( this.entity, entity );
		}
	}
}
