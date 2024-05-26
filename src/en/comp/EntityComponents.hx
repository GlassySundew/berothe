package en.comp;

import en.comp.net.EntityNetComponent;
import core.ClassMap;

class EntityComponents {

	var components : ClassMap<Class<EntityComponent>, EntityComponent> = new ClassMap();

	public function new() {}

	public function add( component : EntityComponent ) {
		components[component.classType] = component;
	}

	public function get<T : EntityNetComponent>( compClass : Class<T> ) : T {
		return cast components[cast compClass];
	}

	public function onAppear<T : EntityComponent>(
		key : Class<T>,
		cb : Class<T> -> T -> Void
	) {
		components.onAppear( cast key, cast cb );
	}
}
