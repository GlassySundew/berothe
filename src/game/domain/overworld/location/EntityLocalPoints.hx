package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import game.data.storage.entity.body.properties.LocalDispatchPointDescription.LocalPointName;

class EntityLocalPoints {

	public final points : Map<LocalPointName, Map<OverworldEntity, ThreeDeeVector>> = [];

	public function new() {}

	public function providePoint(
		name : LocalPointName,
		entity : OverworldEntity,
		point : ThreeDeeVector
	) {
		points[name][entity] = point;
	}

	public inline function getRandomPointByName( name : LocalPointName ) : ThreeDeeVector {
		var point = Random.fromIterable( points[name] );
		return point;
	}
}
