package game.server.level.prefab.mediator;

import hrt.prefab.Prefab;

class PrefabObjectMediator {

	public var level : ServerLevelController;
	public var prefab : Prefab;

	public function new( prefab : Prefab, level : ServerLevelController ) {
		this.level = level;
		this.prefab = prefab;
	}
}
