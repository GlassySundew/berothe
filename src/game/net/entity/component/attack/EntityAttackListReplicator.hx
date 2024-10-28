package game.net.entity.component.attack;

import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.net.entity.component.model.EntityStatsReplicator;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable;
import net.NSMutableProperty;
import util.Assert;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;

class EntityAttackListReplicator extends EntityComponentReplicatorBase {

	@:s final isRaised : NSMutableProperty<Bool> = new NSMutableProperty<Bool>();

	override function followComponentServer(
		component : EntityComponent,
		entityRepl : EntityReplicator
	) {
		super.followComponentServer( component, entityRepl );

		#if debug
		Assert.isOfType( component, EntityAttackListComponent );
		#end

		var attackList = Std.downcast( component, EntityAttackListComponent );
		for ( attackItem in attackList.attacksList ) {
			attackItem.isRaised.subscribeProp( isRaised );
			attackItem.onAttackPerformed.add( onEntityAttacked.bind( attackItem.desc.id ) );
		}
	}

	override function followComponentClient( entityRepl : EntityReplicator ) {
		super.followComponentClient( entityRepl );

		followedComponent.then( comp -> {
			var attackList = Std.downcast( comp, EntityAttackListComponent );
			for ( attackItem in attackList.attacksList ) {
				isRaised.subscribeProp( attackItem.isRaised );
				attackItem.onAttackPerformed.add( onEntityAttacked.bind( attackItem.desc.id ) );
			}
		} );
	}

	@:rpc( all )
	function onEntityAttacked( attackItemId : String ) {
		// if ( component.isOwned ) return;

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

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		isRaised.unregister( host, ctx );
	}
}
