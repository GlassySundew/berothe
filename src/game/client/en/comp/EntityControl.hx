package game.client.en.comp;

import game.client.en.comp.control.EntityAttackControlComponent;
import dn.heaps.input.ControllerAccess;
import rx.disposables.ISubscription;
import game.client.en.comp.control.EntityMovementControlComponent;
import game.client.en.comp.control.EntityCameraFollowComponent;
import game.net.entity.EntityReplicator;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityControl {

	var entity : OverworldEntity;

	final ca : ControllerAccess<ControllerAction>;

	public function new( entity : OverworldEntity, entityRepl : EntityReplicator ) {

		ca = Main.inst.controller.createAccess();

		entity.components.add( new EntityCameraFollowComponent( null ) );
		entity.components.add( new EntityMovementControlComponent( entityRepl, ca ) );
		// entity.components.add( new EntityAttackControlComponent( entityRepl, ca ) );
	}
}
