package game.data.location.prefab;

import game.core.rules.overworld.location.ILocationObjectsDataProvider;

class LocationDataResolver {

	public var objectsDataProvider( default, null ) : ILocationObjectsDataProvider;

	public function new( levelType : Data.LocationType ) {
		switch levelType {
			case Prefab( file ): initPrefab( file.file );
		}
	}

	function initPrefab( file : String ) {
		objectsDataProvider = new LocationPrefabSource( file );
	}
}
