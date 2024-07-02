package game.core.rules.overworld.entity;

import game.core.rules.overworld.location.Location;
import core.IProperty;
import core.MutableProperty;
import signals.Signal;
import game.core.rules.overworld.entity.EntityComponents;
import game.core.rules.overworld.location.Chunk;
import game.data.storage.entity.EntityDescription;

class OverworldEntity {

	public final id : String;
	public final desc : EntityDescription;
	public final transform : EntityTransform = new EntityTransform();
	public final components : EntityComponents;

	public final onFrame : Signal<Float> = new Signal<Float>();

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

	public function update( tmod : Float ) {
		onFrame.dispatch( tmod );
	}

	public function addToLocation( location : Location ) {
		locationSelf.val = location;
	}

	public function addToChunk( chunk : Chunk ) {
		chunkSelf.val = chunk;
	}

	@:keep
	public function toString() : String {
		return "Entity: " + desc.id;
	}
}
