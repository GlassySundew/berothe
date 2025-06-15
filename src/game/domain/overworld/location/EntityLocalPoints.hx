package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.physics.Types.Vec;
import game.data.storage.entity.body.properties.LocalDispatchPointDescription.LocalPointName;

class EntityLocalPoints {

	public final points : Map<LocalPointName, Map<OverworldEntity, Vec>> = [];

	public function new() {}

	public function providePoint(
		name : LocalPointName,
		entity : OverworldEntity,
		point : Vec
	) {
		( points[name] ?? ( points[name] = new Map() ) )[entity] = point;
	}

	public inline function getRandomPointByName( name : LocalPointName ) : Vec {
		var point = Random.fromIterable( points[name] );
		return point;
	}
}
