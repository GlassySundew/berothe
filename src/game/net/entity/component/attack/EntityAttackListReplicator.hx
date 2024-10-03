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
			attackItem.isRaised.subscribeProp( isRaised );
			attackItem.onAttackPerformed.add( onPlayerAttacked.bind( attackItem.desc.id ) );
		}
	}

	// override function followComponentServer( component : EntityComponent ) {
	// 	super.followComponentServer( component );
	// 	entity.components.onAppear(
	// 		EntityModelComponent,
	// 		( cl, modelComp ) -> {
	// 		}
	// 	);
	// }

	override function followComponentClient( entityRepl : EntityReplicator ) {
		super.followComponentClient( entityRepl );

		followedComponent.then( comp -> {
			var attackList = Std.downcast( comp, EntityAttackListComponent );
			for ( attackItem in attackList.attackComponents ) {
				isRaised.subscribeProp( attackItem.isRaised );
				attackItem.onAttackPerformed.add( onPlayerAttacked.bind( attackItem.desc.id ) );
			}
		} );
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

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		isRaised.unregister( host, ctx );
	}
}
