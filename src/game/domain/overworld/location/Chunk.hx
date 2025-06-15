package game.domain.overworld.location;

import echoes.Entity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import rx.disposables.ISubscription;
import rx.ObservableFactory;
import rx.Observable;
import signals.Signal;
import util.Assert;

class Chunk {

	public final x : Int;
	public final y : Int;
	public final z : Int;
	public final size : Int;
	// final onEntityAdded : Signal<Entity> = new Signal<Entity>();
	// final onEntityRemoved : Signal<Entity> = new Signal<Entity>();
	// final onEntityMoved = new Signal<Entity>();
	public var entities( default, null ) : Array<Entity> = [];

	// final entitySubs : Map<Entity, ISubscription> = [];

	public function new( x : Int, y : Int, z : Int, size : Int, location : OverworldLocationMain ) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.size = size;
	}

	public function addEntity( entity : Entity ) {
		#if debug
		Assert.notExistsInArray( entity, entities );
		#end

		entities.push( entity );
	}

	public function removeEntity( entity : Entity ) {
		if ( !entities.remove( entity ) ) {
			trace( "entity: " + entity + " was not found in the chunk it has to be removed from" );
		}
	}

	@:keep
	public function toString() : String {
		return 'Chunk: x: $x, y: $y, z: $z';
	}

	// function onEntityMove( entity : Entity ) {
	// 	onEntityMoved.dispatch( entity );
	// }
}
