package game.core.rules.overworld.location;

import game.core.rules.overworld.entity.OverworldEntity;
import util.Assert;

class Chunk {

	var entities : Array<OverworldEntity> = [];

	public function new() {}

	public function addEntity( entity : OverworldEntity ) {
		#if debug
		Assert.notExistsInArray( entity, entities );
		#end

		entities.push( entity );
	}
}
