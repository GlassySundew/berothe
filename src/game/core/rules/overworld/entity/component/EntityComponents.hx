package game.core.rules.overworld.entity.component;

import haxe.ds.StringMap;
import core.ClassMap;
import util.Assert;

class EntityComponents {

	var components : ClassMap<Class<EntityComponent>, EntityComponent> = new ClassMap();

	public function new() {}

	public function add( component : EntityComponent ) {
		#if debug
		Assert.notExistsInClassMap(component, components);
		#end

		components[component.classType] = component;
	}

	public function get<T : EntityComponent>( compClass : Class<T> ) : T {
		return cast components[cast compClass];
	}

	public function onAppear<T : EntityComponent>(
		key : Class<T>,
		cb : Class<T> -> T -> Void
	) {
		components.onAppear( cast key, cast cb );
	}
}