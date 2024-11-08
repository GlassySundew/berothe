package game.client.en.comp.control;

import dn.heaps.input.ControllerAccess;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.net.entity.EntityReplicator;

class EntityAttackControlComponent extends EntityClientComponent {

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
