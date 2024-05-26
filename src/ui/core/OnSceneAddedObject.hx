package ui.core;

import signals.Signal;
import h2d.Object;

class OnSceneAddedObject extends Object {

	public var onAddedToSceneEvent = new Signal();

	override function onAdd() {
		super.onAdd();
		if ( getScene() != null )
			onAddedToSceneEvent.dispatch();
	}

	override function onRemove() {
		super.onRemove();
		onAddedToSceneEvent.remove( true );
		onAddedToSceneEvent = null;
	}
}
