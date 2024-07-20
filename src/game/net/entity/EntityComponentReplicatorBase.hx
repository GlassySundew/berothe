package game.net.entity;

import net.NSMutableProperty;
import util.Assert;
import game.data.storage.DataStorage;
import game.core.rules.overworld.entity.EntityComponents;
import future.Future;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.EntityComponent;
import net.NetNode;

/**
	когда базовый класс `EntityComponentReplicator` реплицируется на клиент, 
	то он автоматически создаёт "чистый" компонент, и, если он привязан к
	сущности(из `EntityReplicator`), то будет вызвана `followComponentClient()`
**/
abstract class EntityComponentReplicatorBase extends NetNode {

	public var classType( default, null ) : Class<EntityComponentReplicatorBase>;
	public var followedComponent( default, null ) : Future<EntityComponent> = new Future();

	@:s var componentDescId : NSMutableProperty<String> = new NSMutableProperty();
	var entity : OverworldEntity;

	override function init() {
		classType = Type.getClass( this );
		super.init();
	}
	override function alive() {
		super.alive();

		componentDescId.onAppear( descId -> {
			var desc = DataStorage.inst.entityPropertiesStorage.getDescriptionById( descId );
			followedComponent.resolve( desc.buildComponennt() );
		} );
	}

	public function followComponentClient( entity : OverworldEntity ) {
		this.entity = entity;
		followedComponent.then( ( component ) -> entity.components.add( component ) );
	}

	public function followComponentServer( component : EntityComponent ) : Void {
		entity = component.entity;
		componentDescId.val = component.description.id.toString();
		followedComponent.resolve( component );
	}
}
