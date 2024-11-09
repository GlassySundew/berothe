package game.data.location.prefab;

import game.data.storage.location.LocationDescription.LocationType;
import game.domain.overworld.location.ILocationObjectsDataProvider;

class LocationDataResolver {

	public var objectsDataProvider( default, null ) : ILocationObjectsDataProvider;

	public function new( levelType : LocationType ) {
		switch levelType {
			case Prefab( file ): initPrefab( file );
		}
	}

	function initPrefab( file : String ) {
		objectsDataProvider = new LocationPrefabSource( file );
	}
}
