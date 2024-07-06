package game.data.storage.entity.body.view;

class EntityComposerViewDescription implements IEntityViewProvider {

	final animations : Data.EntityBody_view_animations;

	public function new( animations : Data.EntityBody_view_animations ) {
		this.animations = animations;
	}

	public function createView( setting : EntityViewExtraInitSetting ) : ThreeDObjectNode {
		throw new haxe.exceptions.NotImplementedException();
	}
}
