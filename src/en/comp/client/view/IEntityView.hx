package en.comp.client.view;

import h3d.scene.Object;
import en.comp.client.EntityViewComponent.AnimationKey;

interface IEntityView {

	function getSceneObject() : Object;
	function setPosition( x : Float, y : Float, z : Float ) : Void;
	function playAnimation( animationKey : AnimationKey, ?overrideSpeed : Null<Float> ) : Void;
}
