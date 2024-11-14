package game.net.entity.component;

import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.component.combat.EntityDamageType;
import net.NSMutableProperty;
import core.MutableProperty;
import game.data.storage.DataStorage;
import net.NSArray;
import game.net.entity.component.model.EntityStatsReplicator;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.component.model.EntityInventoryReplicator;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import game.net.entity.component.model.EntityEquipReplicator;
import game.domain.overworld.entity.EntityComponent;

class EntityModelComponentReplicator extends EntityComponentReplicatorBase {

	@:s final factionsRepl : NSArray<String> = new NSArray();
	@:s final isSleeping : NSMutableProperty<Bool> = new NSMutableProperty<Bool>();
	@:s var statsRepl : EntityStatsReplicator;
	@:s var equipRepl : EntityEquipReplicator;
	@:s var inventoryRepl : EntityInventoryReplicator;

	override function followComponentServer( component : EntityComponent, entityRepl ) {
		super.followComponentServer( component, entityRepl );

		var modelComp = Std.downcast( component, EntityModelComponent );

		statsRepl = new EntityStatsReplicator( modelComp.stats, entityRepl, this );
		equipRepl = new EntityEquipReplicator( modelComp.inventory, entityRepl, this );
		inventoryRepl = new EntityInventoryReplicator( modelComp.inventory, this );
		modelComp.factions.subscribe( ( i, val ) -> if ( val != null ) factionsRepl[i] = val.id );
		modelComp.isSleeping.subscribeProp( isSleeping );
		modelComp.onDamaged.add( onDamaged );
	}

	#if client
	override function followComponentClient( entityRepl : EntityReplicator ) {
		super.followComponentClient( entityRepl );

		followedComponent.then( ( comp ) -> {
			var modelComp : EntityModelComponent = Std.downcast( comp, EntityModelComponent );
			equipRepl.followClient( modelComp.inventory, entityRepl );
			inventoryRepl.followClient( modelComp.inventory );
			factionsRepl.subscribleWithMapping(
				( i, faction ) -> {
					modelComp.factions.set( i, DataStorage.inst.factionStorage.getById( faction ) );
				}
			);
			isSleeping.subscribeProp( modelComp.isSleeping );
		} );
	}
	#end

	@:rpc( clients )
	function onDamaged( amount : Float, type : EntityDamageType ) {
		#if client
		var view = entityRepl.entity.result.components.get( EntityViewComponent );
		view.statusBar?.sayChatMessage( Std.string( amount ) );
		#end
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		equipRepl.unregister( host, ctx );
		inventoryRepl.unregister( host, ctx );
		factionsRepl.unregister( host, ctx );
	}
}
