package game.domain.overworld.entity;

import util.Assert;
import future.Future;
import game.domain.overworld.entity.component.EntityRigidBodyComponent;
import game.domain.overworld.location.Location;
import core.IProperty;
import core.MutableProperty;
import signals.Signal;
import game.domain.overworld.entity.EntityComponents;
import game.domain.overworld.location.Chunk;
import game.data.storage.entity.EntityDescription;

class OverworldEntity {

	public final id : String;
	public final desc : EntityDescription;
	public final transform : EntityTransform = new EntityTransform();
	public final components : EntityComponents;

	public final onFrame : Signal<Float, Float> = new Signal<Float, Float>();
	public final disposed : Future<Bool> = new Future();
	public final postDisposed : Future<Bool> = new Future();

	var chunkSelf : MutableProperty<Chunk> = new MutableProperty<Chunk>();
	public var chunk( get, never ) : IProperty<Chunk>;
	inline function get_chunk() : IProperty<Chunk> {
		return chunkSelf;
	}

	var locationSelf : MutableProperty<Location> = new MutableProperty<Location>();
	public var location( get, never ) : IProperty<Location>;
	inline function get_location() : IProperty<Location> {
		return locationSelf;
	}

	public function new( entityDesc : EntityDescription, id : String ) {
		this.desc = entityDesc;
		components = new EntityComponents( this );
		this.id = id;
	}

	public function dispose() {
		Assert.isFalse( disposed.isTriggered, this + " entity double dispose" );
		components.dispose();
		disposed.resolve( true );
		postDisposed.resolve( true );
	}

	public inline function update( dt : Float, tmod : Float ) {
		onFrame.dispatch( dt, tmod );
	}

	public function setLocation( location : Location ) {
		locationSelf.val = location;
	}

	public function addToChunk( chunk : Chunk ) {
		chunkSelf.val = chunk;
	}

	public function removeChunk() {
		chunkSelf.val = null;
	}

	@:keep
	public function toString() : String {
		return "Entity: " + desc.id;
	}
}
