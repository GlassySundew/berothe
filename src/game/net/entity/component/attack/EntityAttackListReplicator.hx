package game.net.entity.component.attack;

import game.core.rules.overworld.entity.component.combat.EntityAttackListItem;
import hxbit.NetworkSerializable.Operation;
import hxbit.NetworkSerializable;
import game.core.rules.overworld.entity.component.combat.EntityAttackListComponent;
import util.Assert;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityAttackListReplicator extends EntityComponentReplicatorBase {

	var isOwned : Bool = #if server true #else false #end;

	public function claimOwnage() {
		followedComponent.then( onComponentAppeared );
		isOwned = true;
	}

	function onComponentAppeared( comp : EntityComponent ) {
		#if debug
		Assert.isOfType( comp, EntityAttackListComponent );
		#end

		var attackList = Std.downcast( comp, EntityAttackListComponent );
		for ( attackItem in attackList.attackComponents ) {
			attackItem.onAttackPerformed.add( onPlayerAttacked.bind( attackItem.desc.id ) );
		}
	}

	@:rpc( all )
	function onPlayerAttacked( attackItemId : String ) {
		if ( isOwned ) return;

		var attackList = Std.downcast( component, EntityAttackListComponent );
		attackList.getItemByItemDescId( attackItemId ).attack( true );
	}

	override function networkAllow(
		mode : Operation,
		prop : Int,
		client : NetworkSerializable
	) : Bool {
		return true;
	}
}
