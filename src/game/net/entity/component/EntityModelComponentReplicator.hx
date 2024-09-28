package game.net.entity.component;

import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.component.model.EntityInventoryReplicator;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import game.net.entity.component.model.EntityEquipReplicator;
import game.domain.overworld.entity.EntityComponent;

class EntityModelComponentReplicator extends EntityComponentReplicatorBase {

	@:s var equipReplicator : EntityEquipReplicator;
	@:s var inventoryReplicator : EntityInventoryReplicator;

	override function followComponentServer( component : EntityComponent ) {
		super.followComponentServer( component );

		var modelComp = Std.downcast( component, EntityModelComponent );
		var entityRepl = CoreReplicator.inst.getEntityReplicator( entity );
		equipReplicator = new EntityEquipReplicator( modelComp.equip, entityRepl, this );
		inventoryReplicator = new EntityInventoryReplicator( modelComp.inventory, this );
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		equipReplicator.unregister( host, ctx );
		inventoryReplicator.unregister( host, ctx );
	}
}
