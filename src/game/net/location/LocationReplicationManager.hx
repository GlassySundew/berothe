package game.net.location;

import game.core.rules.overworld.location.Location;

class LocationReplicationManager {

	final location : Location;
	final chunks : ChunksReplicatorContainer;

	public function new( location : Location ) {
		this.location = location;
		chunks = new ChunksReplicatorContainer( location );
	}
}
