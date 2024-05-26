package en.comp;

import en.comp.net.EntityNetComponent;
import net.NSClassMap;

class EntityNetComponents extends net.NetNode {

	@:s final components : NSClassMap<Class<EntityNetComponent>, EntityNetComponent>;

	var entity : Entity;

	public function new( entity : Entity, parent ) {
		super( parent );
		components = new NSClassMap<Class<EntityNetComponent>, EntityNetComponent>();
		this.entity = entity;
	}

	public function add( component : EntityNetComponent ) {
		components[component.classType] = component;
	}

	public function get<T : EntityNetComponent>( compClass : Class<T> ) : T {
		return cast components[cast compClass];
	}

	public function onAppear<TLocal : EntityNetComponent>(
		key : Class<TLocal>,
		cb : String -> TLocal -> Void
	) {
		components.onAppear( cast key, cast cb );
	}
}
