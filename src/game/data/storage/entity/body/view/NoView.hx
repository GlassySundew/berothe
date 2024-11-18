package game.data.storage.entity.body.view;

import game.client.en.comp.view.EntityViewComponent;
import graphics.ObjectNode3D;
import game.client.en.comp.view.EntitySimpleObject;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;

class NoView implements IEntityViewProvider {

	public inline function new() {}

	public inline function createView(
		viewComponent : EntityViewComponent,
		setting : Array<EntityViewExtraInitSetting>
	) : IEntityView {
		return new EntitySimpleObject();
	}
}
