package game.domain.overworld;

import hx.concurrent.collection.OrderedCollection;
import hx.concurrent.collection.SynchronizedArray;
import game.domain.overworld.config.EntityCreationConfig;
import game.domain.overworld.location.Chunks;
import game.domain.overworld.location.OverworldLocationMain;

class OverworldContext implements IOverworldContext {

	public var entitySpawnConfigs( default, null ) : OrderedCollection<EntityCreationConfig>;
	public var chunks( default, null ) : Chunks;

	public function new( location : OverworldLocationMain ) {

		entitySpawnConfigs = new SynchronizedArray();
		chunks = new Chunks( location, location.locationDesc.chunkSize );
	}
}
