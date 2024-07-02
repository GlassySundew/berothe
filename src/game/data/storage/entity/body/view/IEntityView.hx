package game.data.storage.entity.body.view;

import graphics.ThreeDObjectNode;

enum EntityViewInitializationSetting {
	None;
	Size( x : Float, y : Float, z : Float );
}

interface IEntityView {

	function createView( setting : EntityViewInitializationSetting ) : ThreeDObjectNode;
}
