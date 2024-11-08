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

	public final onComponentAdded : Signal<EntityComponent> = new Signal<EntityComponent>();
	public final components : ClassMap<Class<EntityComponent>, EntityComponent> = new ClassMap();
	public final componentStream : Observable<EntityComponent>;
	final entity : OverworldEntity;


	public function new( entity : OverworldEntity ) {
		this.entity = entity;

		componentStream = ObservableFactory.ofIterable( components )
			.append( ObservableFactory.fromSignal( onComponentAdded ) );
	}

	public function dispose() {
		for ( component in components ) {
			component.dispose();
		}
	}

	public function add( component : EntityComponent ) {
		#if debug
		Assert.notExistsInClassMap( component, components );
		#end

		onComponentAdded.dispatch( component );
		component.attachToEntity( entity );
		components[component.classType] = component;
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
	) : Null<ISubscription> {
		return components.onAppear( cast key, cast cb );
	}

	#if !debug inline #end
	public function onAppearFut<T:EntityComponent>( cl : Class<T> ) : Future<T> {
		var future = new Future<T>();
		onAppear( cl, ( cl, val ) -> future.resolve( val ) );
		return future;
	}
}
