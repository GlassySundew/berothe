package game.core.rules.overworld.location.objects;

import game.data.location.objects.LocationObject;
import game.core.rules.overworld.entity.OverworldEntity;

class OverworldStaticObject {

	public final id : String;
	public final desc : LocationObject;
	public final transform = new OverworldObjectTransform();

	public function new( desc : LocationObject, id : String ) {
		this.desc = desc;
		this.id = id;

	}
}
