package game.physics.oimo;

import game.domain.overworld.entity.OverworldEntity;

class EntityRigidBodyProps {

	public final entity : OverworldEntity;

	inline public function new( entity : OverworldEntity ) {
		this.entity = entity;
	}
}
