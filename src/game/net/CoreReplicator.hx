package game.net;

import util.Assert;
import game.domain.overworld.GameCore;
import game.domain.overworld.location.OverworldLocationMain;
import game.net.location.OverworldLocationReplicator;
#if macro
import haxe.macro.Expr;
#end

class CoreReplicator {

	public final locations : Map<String, OverworldLocationReplicator> = [];

	final core : GameCore;

	public function new( core : GameCore ) {

		this.core = core;

		core.onLocationCreated.add( onLocationCreated );
	}

	function onLocationCreated( location : OverworldLocationMain ) {
		#if debug
		Assert.notExistsInMap(
			location.id,
			locations,
			"location id interfere check failed in main replication module!"
		);
		#end
		locations[location.id] = new OverworldLocationReplicator( location, this );
		location.disposed.then( _ -> {
			locations[location.id].dispose();
			locations.remove( location.id );
		} );
	}
}
