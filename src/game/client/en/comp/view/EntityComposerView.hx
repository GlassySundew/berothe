package game.client.en.comp.view;

import plugins.bodyparts_animations.src.customObj.EntityComposer;
import graphics.ThreeDObjectNode;

class EntityComposerView implements IEntityView {

	final entityComposerPrefab : EntityComposer;
	final object : ThreeDObjectNode;

	public function new( file : String ) {
		var prefabSource = Std.downcast( hxd.Res.load( file ).toPrefab().load(), EntityComposer );
		entityComposerPrefab = prefabSource.make();
		object = ThreeDObjectNode.fromHeapsObject( entityComposerPrefab.local3d );
	}

	public function getGraphics() : ThreeDObjectNode {
		return object;
	}

	public function playAnimation( animationKey : AnimationKey, ?overrideSpeed : Float ) {}
}
