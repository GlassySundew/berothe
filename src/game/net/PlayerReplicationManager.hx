package game.net;

import game.core.rules.overworld.location.Chunk;
import game.core.rules.overworld.location.Location;
import game.core.rules.overworld.entity.OverworldEntity;
import net.ClientController;

/**
	`PlayerReplicationManager` manages singular player sight objects
**/
class PlayerReplicationManager {

	final cliCon : ClientController;
	final entity : OverworldEntity;

	public function new(
		cliCon : ClientController,
		entity : OverworldEntity
	) {
		this.cliCon = cliCon;
		this.entity = entity;
	}

	public function init() {
		entity.onAddedToChunk.add( onAddedToChunk );
	}

	function onAddedToChunk( chunk : Chunk ) {
		
	}
}
