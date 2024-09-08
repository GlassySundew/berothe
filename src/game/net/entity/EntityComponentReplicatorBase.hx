package game.net.entity;

import game.client.en.comp.view.EntityViewComponent;
import future.Future;
import net.NSMutableProperty;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.data.storage.DataStorage;

/**
	когда базовый класс `EntityComponentReplicator` реплицируется на клиент, 
	то он автоматически создаёт "чистый" компонент, и, если он привязан к
	сущности(из `EntityReplicator`), то будет вызвана `followComponentClient()`
**/
abstract class EntityComponentReplicatorBase extends NetNode {

	public var classType( default, null ) : Class<EntityComponentReplicatorBase>;
	public var followedComponent( default, null ) : Future<EntityComponent> = new Future();
	public var component( default, null ) : EntityComponent;

	@:s var componentDescId : NSMutableProperty<String> = new NSMutableProperty();
	var entity : OverworldEntity;

	override function init() {
		classType = Type.getClass( this );
		super.init();
	}

	final override function alive() {
		super.alive();

		componentDescId.onAppear( descId -> {
			var desc = DataStorage.inst.entityPropertiesStorage.getDescriptionById( descId );
			component = desc.buildComponennt();
			followedComponent.resolve( component );
		} );
	}

	public function followComponentClient( entity : OverworldEntity ) {
		this.entity = entity;
		followedComponent.then( ( component ) -> {
			entity.components.add( component );
		} );
	}

	public function followComponentServer( component : EntityComponent ) : Void {
		entity = component.entity;
		this.component = component;
		componentDescId.val = component.description.id.toString();
		followedComponent.resolve( component );
	}
}
