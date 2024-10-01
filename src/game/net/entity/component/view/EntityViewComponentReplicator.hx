package game.net.entity.component.view;

import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import net.NSMutableProperty;
import game.net.entity.EntityComponentReplicatorBase;

class EntityViewComponentReplicator extends EntityComponentReplicatorBase {

	override function followComponentClient( entity ) {
		super.followComponentClient( entity );

		followedComponent.then( ( component ) -> {

		} );
	}
}
