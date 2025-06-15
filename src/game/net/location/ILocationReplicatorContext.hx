package game.net.location;

import hx.concurrent.collection.OrderedCollection;
import game.net.entity.EntityReplicator;
import net.ClientController;

interface ILocationReplicatorContext {

	public var chunksReplicator( default, null ) : ChunksReplicationManager;
	public var entityReplicators( default, null ) : OrderedCollection<EntityReplicator>;
	public var cliCons( default, null ) : OrderedCollection<ClientController>;
}
