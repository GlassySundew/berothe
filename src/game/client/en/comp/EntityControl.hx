package game.client.en.comp;

import util.Assert;
import game.net.entity.component.attack.EntityAttackListReplicator;
import game.core.rules.overworld.entity.component.EntityRigidBodyComponent;
import game.client.en.comp.control.EntityAttackControlComponent;
import dn.heaps.input.ControllerAccess;
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
		entity.components.add( new EntityAttackControlComponent( entityRepl, ca ) );

		entityRepl.transformRepl.createModelToNetworkStream();

		entity.components.onAppear( EntityRigidBodyComponent, ( key, rbComp ) -> {
			rbComp.claimOwnage();
		} );

		entityRepl.componentsRepl.components.onAppear(
			EntityAttackListReplicator,
			( key, compRepl ) -> {
				#if debug
				Assert.isOfType(compRepl, EntityAttackListReplicator);
				#end

				Std.downcast(compRepl, EntityAttackListReplicator);
			}
		);
	}
}
