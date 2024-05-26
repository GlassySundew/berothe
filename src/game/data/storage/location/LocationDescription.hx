package game.data.storage.location;

import game.core.rules.overworld.location.ILocationObjectsDataProvider;
import game.data.location.prefab.LocationDataResolver;

class LocationDescription extends DescriptionBase {

	public final chunkSize : Int;

	var levelType : Data.LocationType;

	public function new( entry : Data.Location ) {
		super( entry.id.toString() );
		levelType = entry.level;
		chunkSize = entry.chunkSize;
	}

	public function createLocationDataResolver() : LocationDataResolver {
		return new LocationDataResolver( levelType );
	}
}
