package game.data.storage.entity.body.view;

import util.Assert;
import game.client.en.comp.view.EntityModelView;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;
import game.client.en.comp.view.EntityViewComponent;
import game.client.en.comp.view.IEntityView;

class ModelObjectViewProvider implements IEntityViewProvider {

	public function new() {}

	public function createView(
		viewComponent : EntityViewComponent,
		settings : Array<EntityViewExtraInitSetting>
	) : IEntityView {
		var view = null;
		for ( setting in settings ) {
			switch setting {
				case File( value ): 
					view = new EntityModelView( value );
					break;
				default: null;
			}
		}

		Assert.notNull( view );

		return view;
	}
}
