package game.data.storage.entity.body.view;

import util.Assert;
import game.client.en.comp.view.EntityViewComponent;
import game.client.en.comp.view.EntityStaticBoxView;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;

class StaticObjectGrayboxViewProvider implements IEntityViewProvider {

	public function new() {}

	public function createView(
		viewComponent : EntityViewComponent,
		settings : Array<EntityViewExtraInitSetting>
	) : IEntityView {
		var view = null;
		for ( setting in settings ) {
			switch setting {
				case Size( x, y, z ):
					view = new EntityStaticBoxView( { x : x, y : y, z : z } );
					break;
				default: null;
			}
		}

		Assert.notNull( view );

		return view;
	}
}
