package game.core.rules.overworld.entity;

import game.core.rules.overworld.location.Chunk;
import future.Future;
import signals.Signal;
import game.core.rules.overworld.entity.component.EntityComponents;
import game.core.rules.overworld.location.Location;
import game.data.storage.entity.EntityDescription;

class OverworldEntity {

	public final transform : EntityTransform = new EntityTransform();

	var entityComponents : EntityComponents = new EntityComponents();
	var entityDesc : EntityDescription;

	public var chunk : Chunk;
	public var onAddedToChunk( default, null ) : Signal<Chunk> = new Signal<Chunk>();

	public function new( entityDesc : EntityDescription ) {
		this.entityDesc = entityDesc;
	}

	public function addToChunk( Chunk : Chunk ) {
		onAddedToChunk.dispatch( chunk );
	}
}
