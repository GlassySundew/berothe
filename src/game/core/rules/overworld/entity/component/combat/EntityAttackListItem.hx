package game.core.rules.overworld.entity.component.combat;

import game.core.rules.overworld.location.Location;
import game.data.storage.entity.body.properties.AttackListItemDescription;
import game.physics.oimo.OimoTweenBoxCastEmitter;
import oimo.collision.geometry.BoxGeometry;
import game.data.storage.entity.body.view.AttackTranslationTween;

class EntityAttackListItem {

	final attackDescription : AttackListItemDescription;

	var emitter : OimoTweenBoxCastEmitter;

	public function new( desc : AttackListItemDescription ) {
		this.attackDescription = desc;
	}

	public function attachToEntity( entity : OverworldEntity ) {
		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {
		emitter = new OimoTweenBoxCastEmitter( attackDescription, location.physics );
	}
}
