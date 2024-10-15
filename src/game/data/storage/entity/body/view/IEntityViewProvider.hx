package game.data.storage.entity.body.view;

import game.client.en.comp.view.EntityViewComponent;
import game.client.en.comp.view.IEntityView;
import graphics.ThreeDObjectNode;

enum EntityViewExtraInitSetting {
	None;
	Size( x : Float, y : Float, z : Float );
	File( value : String );
}

interface IEntityViewProvider {

	function createView(
		viewComponent : EntityViewComponent,
		setting : Array<EntityViewExtraInitSetting>
	) : Null<IEntityView>;
}
