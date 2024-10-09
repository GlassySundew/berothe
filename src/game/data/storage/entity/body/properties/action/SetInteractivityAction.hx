package game.data.storage.entity.body.properties.action;

import game.domain.overworld.entity.component.EntityInteractableComponent;
import game.domain.overworld.entity.OverworldEntity;

class SetInteractivityAction extends BodyActionBase {

	final value : Bool;

	public function new( value : Bool ) {
		this.value = value;
	}

	public function perform(
		self : OverworldEntity,
		user : OverworldEntity
	) {
		var interactComp = self.components.get( EntityInteractableComponent );
		interactComp.interactionBoolList.removeLambda( predicament );
		interactComp.interactionBoolList.addLambda( predicament );
	}

	function predicament() : Bool {
		return value;
	}
}
