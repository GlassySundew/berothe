package game.net.entity.component.view;

import game.domain.overworld.entity.EntityComponent;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import net.NSMutableProperty;
import game.net.entity.EntityComponentReplicatorBase;

class EntityViewComponentReplicator extends EntityComponentReplicatorBase {

	@:s final isBatched : NSMutableProperty<Bool> = new NSMutableProperty();

	override function followComponentServer(
		component : EntityComponent,
		entityRepl : EntityReplicator
	) {
		super.followComponentServer( component, entityRepl );
		Std.downcast( component, EntityViewComponent ).isBatched.subscribeProp( isBatched );
		isBatched.addOnValue( ( _, newVal ) -> trace( newVal ) );
	}
}
