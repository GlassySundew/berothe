package game.net.entity;

import future.Future;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;

/**
	когда базовый класс `EntityComponentReplicator` реплицируется на клиент, 
	то он автоматически создаёт "чистый" компонент, и, если он привязан к
	сущности(из `EntityReplicator`), то будет вызвана `followComponentClient()`
**/
abstract class EntityComponentReplicatorBase extends NetNode {

	public var classType( default, null ) : Class<EntityComponentReplicatorBase>;
	public var followedComponent( default, null ) : Future<EntityComponent> = new Future();
	public var component( default, null ) : EntityComponent;

	@:s var componentDescId : String;
	@:s var entityRepl : EntityReplicator;

	override function init() {
		classType = Type.getClass( this );
		super.init();
	}

	public function dispose() {
		component = null;
	}

	override function alive() {
		super.alive();

		var desc = entityRepl.entity.result.desc.getBodyDescription().getComponentDescription( componentDescId );
		component = desc.buildComponent();
		followedComponent.resolve( component );
	}

	public function followComponentClient( entityRepl : EntityReplicator ) {
		this.entityRepl = entityRepl;
		followedComponent.then( ( component ) -> {
			entityRepl.entity.result.components.add( component );
		} );
	}

	public function followComponentServer(
		component : EntityComponent,
		entityRepl : EntityReplicator
	) : Void {
		this.entityRepl = entityRepl;
		this.component = component;
		componentDescId = component.description.id.toString();
		followedComponent.resolve( component );
	}
}
