package game.domain.overworld;

import game.domain.overworld.config.EntityCreationConfig;
import hx.concurrent.collection.Queue;

interface IOverworldContext {

	var entityCreationQueue( default, null ) : Queue<EntityCreationConfig>;
}
