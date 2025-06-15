package game.data.storage.entity.body.properties.action;

import game.data.storage.entity.body.properties.action.ActionsFactory.Transform;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.physics.Types.Vec;

class ToggleEntityTransformInListAction extends BodyActionBase {

	public var transformIndex : Int = 0;

	final transforms : Array<Transform>;

	public function new( transforms : Array<Transform> ) {
		this.transforms = transforms;
	}

	function perform(
		self : OverworldEntity,
		user : OverworldEntity
	) {
		var transform = transforms[transformIndex];
		if ( transform.rotation != null ) {
			self.transform.setRotation(
				self.transform.rotationX.val + transform.rotation.x,
				self.transform.rotationY.val + transform.rotation.y,
				self.transform.rotationZ.val + transform.rotation.z
			);
		}

		transformIndex = ( transformIndex + 1 ) % transforms.length;
	}
}
