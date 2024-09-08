package game.domain.overworld.location;

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

	var entities : Array<OverworldEntity> = [];

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

		var oldChunk = entity.chunk.getValue();

		onEntityAdded.dispatch( entity );

		entities.push( entity );
		entity.addToChunk( this );

		oldChunk?.removeEntity( entity );
	}

	public function removeEntity( entity : OverworldEntity ) {
		if ( entities.remove( entity ) ) onEntityRemoved.dispatch( entity );
	}

	@:keep
	public function toString() : String {
		return 'Chunk: x: $x, y: $y, z: $z';
	}
}
