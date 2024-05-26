package game.server.entity.factory;

import net.ClientController;
import net.NetNode;
import en.Entity;
import net.Server;
import game.data.storage.DataStorage;
import game.server.entity.EntityServerUtil;
import en.util.EntityUtil;

@:deprecated
class ServerEntityFactory {

	public var game : GameServer;

	public function new( game : GameServer ) {
		this.game = game;
	}

	public function createEntity(
		entityCdbId : Data.EntityBodyKind
	) : Entity {
		
		var entity = Type.createInstance( Entity, [] );
		EntityPropertyFactory.fromCdbProperties(
			entity,
			Data.entityBody.get( entityCdbId ).properties
		);
		entity.model.cdb.val = entityCdbId;

		return entity;
	}

	public inline function createPlayer(
		nickname : String,
		clientController : ClientController
	) {
		Server.inst.log( "Client identified ( nickname: " + nickname + ")" );

		var player = createNewPlayer();

		EntityServerUtil.givePlayerControlOverEntity( player, clientController );
	}

	function createNewPlayer() : Entity {
		// var level = game.getLevel( DataStorage.inst.locationStorage.getStartLocationDescription() );
		// level.entityFactory.createEntity();

		// level.
		// level.
		// var spawn = level.entitySpawns.getByName( "player" );
		// var player = spawn.spawnEntity();
		return null;
	}
}

class NetTestObject extends NetNode {

	public function new( ?parent ) {
		super( parent );
		Server.inst.repeater.setS( "n", 1, -1, () -> {
			ping();
		} );
	}

	@:rpc( clients )
	public function ping() {
		trace( "pinged!!!" );
	}
}
