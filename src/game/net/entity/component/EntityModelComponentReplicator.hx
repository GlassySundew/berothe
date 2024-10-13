package game.net.entity.component;

import game.net.entity.component.model.EntityStatsReplicator;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.component.model.EntityInventoryReplicator;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import game.net.entity.component.model.EntityEquipReplicator;
import game.domain.overworld.entity.EntityComponent;

class EntityModelComponentReplicator extends EntityComponentReplicatorBase {

	@:s var statsRepl : EntityStatsReplicator;
	@:s var equipRepl : EntityEquipReplicator;
	@:s var inventoryRepl : EntityInventoryReplicator;

	override function followComponentServer( component : EntityComponent, entityRepl ) {
		super.followComponentServer( component, entityRepl );

		var modelComp = Std.downcast( component, EntityModelComponent );

		statsRepl = new EntityStatsReplicator( modelComp.stats, entityRepl, this );
		equipRepl = new EntityEquipReplicator( modelComp.inventory, entityRepl, this );
		inventoryRepl = new EntityInventoryReplicator( modelComp.inventory, this );
	}

	#if client
	override function followComponentClient( entityRepl : EntityReplicator ) {
		super.followComponentClient( entityRepl );

		followedComponent.then( ( comp ) -> {
			var modelComp : EntityModelComponent = Std.downcast( comp, EntityModelComponent );
			equipRepl.followClient( modelComp.inventory, entityRepl );
			inventoryRepl.followClient( modelComp.inventory );
		} );
	}
	#end

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		equipRepl.unregister( host, ctx );
		inventoryRepl.unregister( host, ctx );
	}
}
