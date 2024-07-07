package en.comp.client.view;

import h3d.scene.Object;

interface IEntityView {

	function getSceneObject() : Object;
	function playAnimation( animationKey : AnimationKey, ?overrideSpeed : Null<Float> ) : Void;
}
