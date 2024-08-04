package game.net.entity.component.attack;

import game.core.rules.overworld.entity.component.combat.EntityAttackListComponent;
import util.Assert;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityAttackListReplicator extends EntityComponentReplicatorBase {

	public function claimOwnage() {
		followedComponent.then( onComponentAppeared );
	}

	function onComponentAppeared( comp : EntityComponent ) {
		#if debug
		Assert.isOfType( comp, EntityAttackListComponent );
		#end

		var attackList = Std.downcast( comp, EntityAttackListComponent );
		for ( attackItem in attackList.attackComponents ) {
			attackItem.onAttackPerformed.add( onPlayerAttacked );
		}
	}

	@:rpc( all )
	function onPlayerAttacked() {
		trace("asd,als,l");
	}

	@:keep
	public function toString() {
		return "AMSDKASMDKKMAS";
	}
}
