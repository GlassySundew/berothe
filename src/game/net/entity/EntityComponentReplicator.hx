package game.net.entity;

import net.NSMutableProperty;
import util.Assert;
import game.data.storage.DataStorage;
import game.core.rules.overworld.entity.EntityComponents;
import future.Future;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.EntityComponent;
import net.NetNode;

abstract class EntityComponentReplicator extends NetNode {

	@:s var componentDescId : NSMutableProperty<String> = new NSMutableProperty();
	var followedComponent( default, null ) : Future<EntityComponent> = new Future();
	var entity : OverworldEntity;

	public function new( parent ) {
		super( parent );
	}

	override function alive() {
		super.alive();

		componentDescId.onAppear( ( descId ) -> {
			var desc = DataStorage.inst.entityPropertiesStorage.getDescriptionById( descId );
			followedComponent.resolve( desc.buildComponennt() );
		} );
	}

	public function followComponentClient( entity : OverworldEntity ) {
		followedComponent.then( ( component ) -> entity.components.add( component ) );
	}

	public function followComponentServer( component : EntityComponent ) : Void {
		entity = component.entity;
		componentDescId.val = component.description.id.toString();
		followedComponent.resolve( component );
	}
}
