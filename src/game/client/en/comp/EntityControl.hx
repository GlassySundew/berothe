package game.client.en.comp;

import game.client.en.comp.view.ui.EntityStatsHudMediator;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import haxe.zip.Uncompress;
import game.net.entity.EntityComponentReplicatorBase;
import haxe.zip.Compress;
import haxe.zip.FlushMode;
import util.Assert;
import game.net.entity.component.attack.EntityAttackListReplicator;
import game.domain.overworld.entity.component.EntityRigidBodyComponent;
import game.client.en.comp.control.EntityAttackControlComponent;
import dn.heaps.input.ControllerAccess;
import game.client.en.comp.control.EntityMovementControlComponent;
import game.client.en.comp.control.EntityCameraFollowComponent;
import game.net.entity.EntityReplicator;
import game.domain.overworld.entity.OverworldEntity;

class EntityControl {

	var entity : OverworldEntity;

	final ca : ControllerAccess<ControllerAction>;

	public function new( entity : OverworldEntity, entityRepl : EntityReplicator ) {
		ca = Main.inst.controller.createAccess();

		entity.components.add( new EntityCameraFollowComponent() );
		entity.components.add( new EntityMovementControlComponent( entityRepl, ca ) );
		entity.components.add( new EntityAttackControlComponent( entityRepl, ca ) );

		entity.components.onAppear(
			EntityModelComponent,
			( _, modelComp ) -> {
				new EntityStatsHudMediator(
					modelComp.stats,
					entity,
				);
			}
		);

		entity.components.onAppear( EntityRigidBodyComponent, ( key, rbComp ) -> {
			rbComp.claimOwnage();
		} );

		entityRepl.transformRepl.createModelToNetworkStream();

		entityRepl.componentsRepl.components.onAppear(
			EntityAttackListReplicator,
			( key, compRepl ) -> {
				#if debug
				Assert.isOfType( compRepl, EntityAttackListReplicator );
				#end

				Std.downcast( compRepl, EntityAttackListReplicator ).claimOwnage();
			}
		);
	}
}
