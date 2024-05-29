package game.core.rules.overworld.location;

import signals.Signal;
import game.core.rules.overworld.entity.OverworldEntity;
import util.Assert;

class Chunk {

	public final x : Int;
	public final y : Int;
	public final z : Int;
	public final onEntityAdded : Signal<OverworldEntity> = new Signal<OverworldEntity>();

	var entities : Array<OverworldEntity> = [];

	public function new( x : Int, y : Int, z : Int ) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function addEntity( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInArray( entity, entities );
		#end

		onEntityAdded.dispatch( entity );

		entities.push( entity );
	}
}
