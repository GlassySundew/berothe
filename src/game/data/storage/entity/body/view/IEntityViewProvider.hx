package game.data.storage.entity.body.view;

import graphics.ThreeDObjectNode;

enum EntityViewExtraInitSetting {
	None;
	Size( x : Float, y : Float, z : Float );
}

interface IEntityViewProvider {

	function createView( setting : EntityViewExtraInitSetting ) : ThreeDObjectNode;
}
