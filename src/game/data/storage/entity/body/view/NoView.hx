package game.data.storage.entity.body.view;

import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import graphics.ThreeDObjectNode;
import game.client.en.comp.view.IEntityView;

class NoView implements IEntityViewProvider {

	public inline function new() {}

	public inline function createView(
		viewComponent : EntityViewComponent,
		setting : Array<EntityViewExtraInitSetting>
	) : IEntityView {
		return null;
	}
}
