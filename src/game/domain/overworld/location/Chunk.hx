package game.domain.overworld.location;

import game.domain.overworld.entity.component.EntityDynamicsComponent;
import rx.disposables.ISubscription;
import rx.ObservableFactory;
import rx.Observable;
import signals.Signal;
import game.domain.overworld.entity.OverworldEntity;
import util.Assert;

class Chunk {

	public final x : Int;
	public final y : Int;
	public final z : Int;
	public final size : Int;
	public final location : Location;
	public final onEntityAdded : Signal<OverworldEntity> = new Signal<OverworldEntity>();
	public final onEntityRemoved : Signal<OverworldEntity> = new Signal<OverworldEntity>();
	public final entityStream : Observable<OverworldEntity>;
	public final onEntityMoved = new Signal<OverworldEntity>();
	public var entities( default, null ) : Array<OverworldEntity> = [];

	final entitySubs : Map<OverworldEntity, ISubscription> = [];

	public function new( x : Int, y : Int, z : Int, size : Int, location : Location ) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.size = size;
		this.location = location;

		entityStream = ObservableFactory.ofIterable( entities )
			.append( ObservableFactory.fromSignal( onEntityAdded ) );
	}

	public function addEntity( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInArray( entity, entities );
		#end

		// ! важно что сначала убираем сущность из чанка, потом добавляем её в другой
		var oldChunk = entity.chunk.getValue();
		if ( oldChunk == this ) return;
		oldChunk?.removeEntity( entity );

		entities.push( entity );
		entity.addToChunk( this );
		var dynamics = entity.components.get( EntityDynamicsComponent );
		if ( dynamics != null ) {
			entitySubs[entity] = dynamics.onMove.add( onEntityMove.bind( entity ) );
		}
		onEntityMove( entity );
		onEntityAdded.dispatch( entity );
	}

	public function removeEntity( entity : OverworldEntity ) {
		if ( entities.remove( entity ) ) {
			entitySubs[entity]?.unsubscribe();
			onEntityRemoved.dispatch( entity );
		} else {
			trace( "entity: " + entity + " was not found in the chunk it has to be removed from" );
		}
	}

	@:keep
	public function toString() : String {
		return 'Chunk: x: $x, y: $y, z: $z';
	}

	function onEntityMove( entity : OverworldEntity ) {
		onEntityMoved.dispatch( entity );
	}
}
