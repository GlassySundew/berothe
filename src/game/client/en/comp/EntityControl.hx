package game.client.en.comp;

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
import game.client.en.comp.view.ui.EntityStatsHudMediator;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.EntityReplicator;

class EntityControl {

	var entity : OverworldEntity;

	final ca : ControllerAccess<ControllerAction>;

	public function new( entity : OverworldEntity, entityRepl : EntityReplicator ) {
		ca = Main.inst.controller.createAccess();

		var cameraFollow = new EntityCameraFollowComponent();
		entity.components.add( cameraFollow );
		entity.components.add( new EntityMovementControlComponent( entityRepl, ca ) );
		entity.components.add( new EntityAttackControlComponent( entityRepl, ca ) );

		entity.components.onAppear(
			EntityModelComponent,
			( _, modelComp ) -> {
				modelComp.displayName.val = Settings.inst.params.nickname;

				new EntityStatsHudMediator(
					modelComp,
					entity,
				);
				new EntityInventoryHudMediator(
					modelComp.inventory
				);
			}
		);

		var sub = null;
		entity.location.addOnValueImmediately( ( oldLoc, newLoc ) -> {
			sub?.unsubscribe();
			sub = Composite.create();
			sub.add( entity.components.componentStream.observe( comp -> {
				if ( Std.isOfType( comp, EntityAttackListComponent ) ) return;
				comp.claimOwnage();
			} ) );
			// waiting for coordinates to syncronize
			GameClient.inst.delayer.addF(() -> {
				cameraFollow.recenter();
			}, 1 );
		} );

		entityRepl.transformRepl.claimOwnage();
		entityRepl.transformRepl.createModelToNetworkStream();
	}
}
