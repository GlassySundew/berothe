package game.domain.overworld;

import context.Context.IModuleContext;
import hx.concurrent.collection.OrderedCollection;
import game.domain.overworld.location.Chunks;
import hx.concurrent.collection.Collection;
import game.domain.overworld.config.EntityCreationConfig;

interface IOverworldContext {

	var entitySpawnConfigs( default, null ) : OrderedCollection<EntityCreationConfig>;
	var chunks( default, null ) : Chunks;
}
