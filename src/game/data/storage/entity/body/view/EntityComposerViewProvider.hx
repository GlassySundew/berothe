package game.data.storage.entity.body.view;

import game.client.en.comp.view.EntityViewComponent;
import game.client.en.comp.view.EntityComposerView;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;

class EntityComposerViewProvider implements IEntityViewProvider {

	final animations : EntityAnimations;
	final file : String;

	public function new( file : String, animations : Data.EntityBody_view_animations ) {
		this.animations = new EntityAnimations( animations );
		this.file = file;
	}

	public function createView(
		viewComponent : EntityViewComponent,
		setting : EntityViewExtraInitSetting
	) : IEntityView {
		return new EntityComposerView( viewComponent, file, animations );
	}
}
