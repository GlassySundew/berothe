package game.core.rules.overworld.location;

import game.data.location.objects.LocationSpawnDescription;
import game.data.storage.entity.EntityDescription;

interface ILocationObjectsDataProvider {

	function load() : Void;
	function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawnDescription>;
}
