package game.client.en.comp;

import util.Assert;
import rx.Subscription;
import util.Settings;
import oimo.common.Setting;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.net.client.GameClient;
import dn.heaps.input.ControllerAccess;
import rx.disposables.Composite;
import game.client.en.comp.control.EntityAttackControlComponent;
import game.client.en.comp.control.EntityCameraFollowComponent;
import game.client.en.comp.control.EntityMovementControlComponent;
import game.client.en.comp.view.ui.EntityInventoryHudMediator;
import game.client.en.comp.view.ui.EntityHealthStatMediator;
import game.client.en.comp.view.ui.EntityStatsHudMediator;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.EntityReplicator;

class EntityControl {

	var entity : OverworldEntity;

	final ca : ControllerAccess<ControllerAction>;

	public function new( entity : OverworldEntity, entityRepl : EntityReplicator ) {
		ca = Main.inst.controller.createAccess();
		var entityDestroySub = Composite.create();

		var cameraFollow = new EntityCameraFollowComponent();
		entity.components.add( cameraFollow );
		entity.components.add( new EntityMovementControlComponent( entityRepl, ca ) );
		entity.components.add( new EntityAttackControlComponent( entityRepl, ca ) );

		entity.components.onAppear(
			EntityModelComponent,
			( _, modelComp ) -> {
				modelComp.displayName.val = Settings.inst.params.nickname;

				var statsMediator = new EntityStatsHudMediator(
					modelComp,
					entity,
				);
				var inventoryMediator = new EntityInventoryHudMediator(
					modelComp.inventory
				);
				var healthStatMediator = new EntityHealthStatMediator(
					modelComp.hp,
					modelComp.stats.maxHp.amount
				);

				entityDestroySub.add( Subscription.create(() -> {
					statsMediator.dispose();
					inventoryMediator.dispose();
					healthStatMediator.dispose();
				} ) );
			}
		);

		entity.components.componentStream.observe( comp -> {
			if ( Std.isOfType( comp, EntityAttackListComponent ) ) return;
			if ( Std.isOfType( comp, EntityModelComponent ) ) return;

			#if debug Assert.isFalse( comp.isOwned ); #end
			comp.claimOwnage();
		} );

		entity.location.addOnValueImmediately( ( oldLoc, newLoc ) -> {
			if ( newLoc == null ) return;
			// waiting for coordinates to syncronize
			GameClient.inst.delayer.addF(() -> {
				cameraFollow.recenter();
			}, 1 );
		} );

		entity.disposed.then( ( _ ) -> {
			entityDestroySub.unsubscribe();
		} );

		entityRepl.transformRepl.claimOwnage();
		entityRepl.transformRepl.createModelToNetworkStream();
	}
}
