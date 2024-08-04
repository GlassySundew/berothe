package game.client.en.comp.control;

import game.core.rules.overworld.entity.component.combat.EntityAttackListComponent;
import game.core.rules.overworld.entity.component.EntityDynamicsComponent;
import game.core.rules.overworld.entity.OverworldEntity;
import dn.heaps.input.ControllerAccess;
import game.net.entity.EntityReplicator;
import game.core.rules.overworld.entity.EntityComponent;

class EntityAttackControlComponent extends EntityComponent {

	public function new(
		entityReplicator : EntityReplicator,
		controller : ControllerAccess<ControllerAction>
	) {
		super();
		this.controller = controller;
	}

	var attackList : EntityAttackListComponent;
	var controller : ControllerAccess<ControllerAction>;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		entity.onFrame.add( update );

		entity.components.onAppear(
			EntityAttackListComponent,
			( key, attackList ) -> {
				this.attackList = attackList;
				entity.onFrame.add( update );
			}
		);
	}

	function update( dt : Float, tmod : Float ) {
		var isControlApplied = controller.isDown( Attack );

		if ( isControlApplied ) attackList.attack();
	}
}
