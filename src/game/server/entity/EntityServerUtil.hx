package game.server.entity;

import net.ClientController;
import en.Entity;

class EntityServerUtil {

	public static function givePlayerControlOverEntity(
		entity : Entity,
		cliCon : ClientController
	) {
		entity.x.syncBack = false;
		entity.y.syncBack = false;
		entity.z.syncBack = false;
		entity.x.syncBackOwner = cliCon;
		entity.y.syncBackOwner = cliCon;
		entity.z.syncBackOwner = cliCon;
		cliCon.giveControlOverEntity( entity );
	}
}
