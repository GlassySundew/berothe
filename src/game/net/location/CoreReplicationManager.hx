package game.net.location;

import game.core.rules.overworld.location.Chunk;
import util.Assert;
import game.core.GameCore;
import game.core.rules.overworld.location.Location;

class CoreReplicationManager {

	final locations : Map<Int, LocationReplicationManager> = [];

	public function new( core : GameCore ) {
		core.onLocationCreated.add( onLocationCreated );
	}

	function onLocationCreated( location : Location ) {
		#if debug
		Assert.notExistsInMap(
			location.id,
			locations,
			"location id interfere check failed in main replication module!"
		);
		#end
		locations[location.id] = new LocationReplicationManager( location );
	}
}
