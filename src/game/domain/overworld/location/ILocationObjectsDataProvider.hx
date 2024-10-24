package game.domain.overworld.location;

import game.data.location.objects.LocationEntityTriggerVO;
import game.data.location.objects.LocationEntityVO;
import game.data.location.objects.LocationSpawnVO;
import game.data.storage.entity.EntityDescription;

interface ILocationObjectsDataProvider {

	function load() : Void;
	function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawnVO>;
	function getGlobalObjects() : Array<LocationEntityVO>;
	function getPresentEntities() : Array<LocationEntityVO>;
	function getTriggers() : Array<LocationEntityTriggerVO>;
}
