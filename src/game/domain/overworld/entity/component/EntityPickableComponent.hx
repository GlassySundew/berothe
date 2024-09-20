package game.domain.overworld.entity.component;

#if server
import game.net.server.GameServer;
#end
import game.data.storage.DataStorage;
import game.domain.overworld.item.model.ItemPickupAttemptResult;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.data.storage.item.EntityPickablePropertyDescription;

class EntityPickableComponent extends EntityComponent {

	public final pickableDesc : EntityPickablePropertyDescription;

	public function new( desc : EntityPickablePropertyDescription ) {
		this.pickableDesc = desc;
		super( desc );

		trace( "creating pickable compo" );
	}

	public function pickupBy( entity : OverworldEntity ) {
		#if client throw "should not be called on client"; #end

		#if server
		var model = entity.components.get( EntityModelComponent );
		var hasSpace = model.hasSpaceForItemDesc(
			pickableDesc.getItemDescription(), 1
		);
		if ( !hasSpace ) return;

		var item = GameCore.inst.itemFactory.createItem(
			DataStorage.inst.itemStorage.getDescriptionById(
				pickableDesc.itemDescId
			)
		);

		model.tryPickupItem( item );
		this.entity.dispose();

		return;
		#end
		// return ;
	}
}
