package game.domain.overworld;

import game.domain.overworld.config.EntityCreationConfig;
import hx.concurrent.collection.Queue;

class OverworldContext implements IOverworldContext {

	public var entityCreationQueue( default, null ) : Queue<EntityCreationConfig>;

	public function new() {

		entityCreationQueue = new Queue();
	}
}
