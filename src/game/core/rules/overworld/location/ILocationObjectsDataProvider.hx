package game.core.rules.overworld.location;

import game.data.location.objects.LocationObject;
import game.data.location.objects.LocationSpawn;
import game.data.storage.entity.EntityDescription;

interface ILocationObjectsDataProvider {

	function load() : Void;
	function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawn>;
	function getGlobalObjects() : Array<LocationObject>;
}
