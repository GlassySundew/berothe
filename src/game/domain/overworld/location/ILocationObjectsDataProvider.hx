package game.domain.overworld.location;

import game.data.location.objects.LocationLinkObjectVO;
import game.data.location.objects.LocationEntityTriggerVO;
import game.data.location.objects.LocationEntityVO;
import game.data.location.objects.LocationSpawnVO;
import game.data.location.objects.LocationObjectVO;
import game.data.storage.entity.EntityDescription;

interface ILocationObjectsDataProvider {

	function load( onComplete : () -> Void ) : Void;
	function getSpawnPoints() : Array<LocationSpawnVO>;
	function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawnVO>;
	function getGlobalObjects() : Array<LocationEntityVO>;
	function getPresentEntities() : Array<LocationEntityVO>;
	function getTriggers() : Array<LocationEntityTriggerVO>;
	function getLocationTransitionExits() : Array<LocationLinkObjectVO>;
}
