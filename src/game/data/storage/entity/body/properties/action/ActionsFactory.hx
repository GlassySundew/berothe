package game.data.storage.entity.body.properties.action;

import tink.CoreApi.Lazy;
import haxe.exceptions.NotImplementedException;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

typedef Transform = {
	?rotation : ThreeDeeVector,
	?position : ThreeDeeVector
};

class ActionsFactory {

	#if !debug inline #end
	public static function fromCdb(
		action : Data.EntityProperty_properties_interactable_actionsQueue_action
	) : Lazy<BodyActionBase> {
		return Lazy.ofFunc(
			(() -> {
				if ( action.toggleEntityTransformInList != null ) {
					return new ToggleEntityTransformInListAction(
						[for ( vector in action.toggleEntityTransformInList ) {
							{
								rotation : new ThreeDeeVector(
									vector.transform.angle?.x ?? 0,
									vector.transform.angle?.y ?? 0,
									vector.transform.angle?.z ?? 0
								)
							}
						}]
					);
				}

				if ( action.setInteractivity != null ) {
					return new SetInteractivityAction( action.setInteractivity );
				}

				if ( action.pickupItem != null ) {
					var itemDescId = action.pickupItem.itemId.toString();
					return new ItemPickupAction( itemDescId );
				}
				throw new NotImplementedException( "empty action:" + action + " not supported" );

			} : () -> BodyActionBase
			) );
	}
}
