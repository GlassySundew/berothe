package game.data.storage.entity.body.properties.action;

import game.domain.overworld.entity.OverworldEntity;

abstract class BodyActionBase {

	abstract public function perform(
		self : OverworldEntity,
		user : OverworldEntity
	) : Void;
}
