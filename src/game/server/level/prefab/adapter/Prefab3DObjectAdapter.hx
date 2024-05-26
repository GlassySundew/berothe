package game.server.level.prefab.adapter;

import game.server.level.prefab.mediator.IPrefabObject;
import game.server.level.block.prefab.Prefab3DObject;
import hrt.prefab.Object3D;

abstract class Prefab3DObjectAdapter<T : IPrefabObject> extends PrefabAdapter<T>  {

	function createObject() {
		var prefab = Std.downcast( mediator.prefab, Object3D );

		var object3D = cast( object, Prefab3DObject );
		object3D.x = prefab.x;
		object3D.y = prefab.y;
		object3D.z = prefab.z;

		object3D.scaleX = prefab.scaleX;
		object3D.scaleY = prefab.scaleY;
		object3D.scaleZ = prefab.scaleZ;

		object3D.rotationX = prefab.rotationX;
		object3D.rotationY = prefab.rotationY;
		object3D.rotationZ = prefab.rotationZ;

		object3D.isVisible = prefab.visible;

		return object;
	}
}
