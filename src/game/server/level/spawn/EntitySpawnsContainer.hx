package game.server.level.spawn;

class EntitySpawnsContainer {

	var entitySpawns : Array<EntitySpawnPoint> = [];
	var spawnsByName : Map<String, EntitySpawnPoint> = [];

	public function new() {}

	public function addSpawn( spawn : EntitySpawnPoint ) {
		entitySpawns.push( spawn );
		spawnsByName[spawn.name] = spawn;
	}

	public function getByName( name : String ) : EntitySpawnPoint {
		return spawnsByName.get( name );
	}
}
