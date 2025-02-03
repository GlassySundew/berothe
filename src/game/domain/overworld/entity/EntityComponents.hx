package game.domain.overworld.entity;

import rx.ObservableFactory;
import rx.Observable;
import future.Future;
import rx.disposables.ISubscription;
import game.domain.overworld.entity.EntityComponent;
import signals.Signal;
import core.ClassMap;
import util.Assert;

class EntityComponents {

	public final container : ClassMap<Class<EntityComponent>, EntityComponent> = new ClassMap();
	final entity : OverworldEntity;

	public function new( entity : OverworldEntity ) {
		this.entity = entity;
	}

	public function dispose() {
		for ( component in container ) {
			component.dispose();
		}
	}

	public function add( component : EntityComponent ) {
		#if debug
		Assert.notExistsInClassMap( component, container );
		#end

		component.attachToEntity( entity );
		container[component.classType] = component;
	}

	#if !debug inline #end
	public function get<T : EntityComponent>( compClass : Class<T> ) : T {
		return cast container[cast compClass];
	}

	#if !debug inline #end
	public function has<T : EntityComponent>( compClass : Class<T> ) {
		return container[cast compClass] != null;
	}

	public function map( func : ( comp : EntityComponent ) -> Void ) {
		for ( component in container ) {
			func( component );
		}
	}

	public function onAppear<T : EntityComponent>(
		key : Class<T>,
		cb : Class<T> -> T -> Void
	) : Null<ISubscription> {
		return container.onAppear( cast key, cast cb );
	}

	#if !debug inline #end
	public function onAppearFut<T : EntityComponent>( cl : Class<T> ) : Future<T> {
		var future = new Future<T>();
		onAppear( cl, ( cl, val ) -> future.resolve( val ) );
		return future;
	}
}
