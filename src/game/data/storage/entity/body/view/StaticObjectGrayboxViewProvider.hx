package game.data.storage.entity.body.view;

import game.client.en.comp.view.EntityStaticBoxView;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;

class StaticObjectGrayboxViewProvider implements IEntityViewProvider {

	public function new() {}

	public function createView( setting : EntityViewExtraInitSetting ) : IEntityView {
		var view = switch setting {
			case Size( x, y, z ):
				new EntityStaticBoxView( { x : x, y : y, z : z } );
			case e:
				throw "graybox required setting Size, got: " + e;
		}

		return view;
	}
}
