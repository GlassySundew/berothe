package game.server;

import util.Const;
import game.server.level.block.GlobalBlocks;
import en.Entity;
import game.server.level.Chunks;
import game.server.level.ILevelObjectsProvider;
import game.server.level.spawn.EntitySpawnsContainer;
import game.server.level.block.Block;
import hxbit.NetworkSerializable;
import net.NSArray;
import oimo.dynamics.World;
import game.Level;

/**
	server level model
**/
class ServerLevelController {

	#if server
	public final entities : NSArray<Entity> = new NSArray();
	public final objectsProvider : ILevelObjectsProvider;

	public var networkLevel( default, null ) : Level;

	public var lvlName : String;
	public var cdb : Data.Location;
	public var sqlId : Null<Int>;
	#end

	public function new( objectsProvider : ILevelObjectsProvider, ?parent ) {
		this.objectsProvider = objectsProvider;

		createNetworkLevel();
	}

	function createNetworkLevel() {
		networkLevel = new Level();
	}

	// TODO destroy itself if has no player instances for 5 seconds
	function gc() {
		for ( e in entities ) {}
	}

	public function attachWatcher( ctx : NetworkSerializer ) {}

	public function attachEntity( entity : Entity ) {
		entities.push( entity );
		entity.model.level = networkLevel;

		entity.onSpawned.trigger( networkLevel );
	}
}
