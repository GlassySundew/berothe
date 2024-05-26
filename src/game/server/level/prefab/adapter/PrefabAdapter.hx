package game.server.level.prefab.adapter;

import haxe.Exception;
import game.server.level.prefab.mediator.IPrefabObject;
import game.server.level.prefab.mediator.PrefabObjectMediator;

abstract class PrefabAdapter<T : IPrefabObject> {

	var mediator : PrefabObjectMediator;
	var object : T;

	public function new( mediator : PrefabObjectMediator ) {
		this.mediator = mediator;

		object = createObject();

		if ( object == null )
			throw new Exception( "prefab adapter " + this + " has failed to create an object" );

		object.initPrefab();
	}

	abstract public function createObject() : T;
}
