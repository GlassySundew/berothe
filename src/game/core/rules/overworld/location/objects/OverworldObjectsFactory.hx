package game.core.rules.overworld.location.objects;

import game.data.location.objects.LocationObject;

class OverworldObjectsFactory {

	public static var OBJECT_ID_INC = 0;

	final location : Location;

	public function new( location : Location ) {
		this.location = location;
	}

	public function byDesc( objectDesc : LocationObject ) : OverworldStaticObject {
		return new OverworldStaticObject( objectDesc, '${OBJECT_ID_INC++}' );
	}
}
