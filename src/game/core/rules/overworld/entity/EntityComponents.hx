package game.core.rules.overworld.entity;

import game.core.rules.overworld.entity.EntityComponent;
import signals.Signal;
import core.ClassMap;
import util.Assert;

class EntityComponents {

	public final onComponentAdded : Signal<EntityComponent> = new Signal<EntityComponent>();
	final entity : OverworldEntity;

	var components : ClassMap<Class<EntityComponent>, EntityComponent> = new ClassMap();

	public function new( entity : OverworldEntity ) {
		this.entity = entity;
	}

	public function add( component : EntityComponent ) {
		#if debug
		Assert.notExistsInClassMap( component, components );
		#end

		components[component.classType] = component;
		onComponentAdded.dispatch( component );
		component.attachToEntity( entity );
	}

	public function get<T : EntityComponent>( compClass : Class<T> ) : T {
		return cast components[cast compClass];
	}

	public function map( func : ( comp : EntityComponent ) -> Void ) {
		for ( component in components ) {
			func( component );
		}
	}

	public function onAppear<T : EntityComponent>(
		key : Class<T>,
		cb : Class<T> -> T -> Void
	) {
		components.onAppear( cast key, cast cb );
	}
}