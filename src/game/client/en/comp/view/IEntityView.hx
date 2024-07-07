package game.client.en.comp.view;

import core.MutableProperty;
import graphics.ThreeDObjectNode;
import h3d.scene.Object;

interface IEntityView {

	function getGraphics() : ThreeDObjectNode;
	function playAnimation( animationKey : AnimationKey, ?overrideSpeed : Null<Float> ) : Void;
}
