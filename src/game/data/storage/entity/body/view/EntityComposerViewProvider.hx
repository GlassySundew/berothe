package game.data.storage.entity.body.view;

import haxe.extern.EitherType;
import game.client.en.comp.view.EntityViewComponent;
import game.client.en.comp.view.EntityComposerView;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;

class EntityComposerViewProvider implements IEntityViewProvider {

	final animations : EntityAnimations;
	final file : String;

	public function new(
		file : String,
		animations : EitherType<
			cdb.Types.ArrayRead<Data.EntityView_animations>,
			cdb.Types.ArrayRead<Data.ItemEquipAsset_animations>
			>
	) {
		this.animations = new EntityAnimations( animations );
		this.file = file;
	}

	public function createView(
		viewComponent : EntityViewComponent,
		setting : Array<EntityViewExtraInitSetting>
	) : IEntityView {
		return new EntityComposerView( viewComponent, file, animations );
	}
}
