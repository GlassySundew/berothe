package game.net.location;

import game.net.entity.EntityReplicator;
import hx.concurrent.collection.SynchronizedArray;
import hx.concurrent.collection.OrderedCollection;
import net.ClientController;
import game.domain.overworld.location.OverworldLocationMain;

class LocationReplicatorContext implements ILocationReplicatorContext {

	public var chunksReplicator( default, null ) : ChunksReplicationManager;
	public var entityReplicators( default, null ) : OrderedCollection<EntityReplicator>;
	public var cliCons( default, null ) : OrderedCollection<ClientController>;

	final location : OverworldLocationMain;
	final coreReplicator : CoreReplicator;

	public function new( location : OverworldLocationMain, coreReplicator : CoreReplicator ) {

		this.location = location;
		this.coreReplicator = coreReplicator;

		chunksReplicator = new ChunksReplicationManager( location, coreReplicator );
		entityReplicators = new SynchronizedArray();
		cliCons = new SynchronizedArray();
	}
}
