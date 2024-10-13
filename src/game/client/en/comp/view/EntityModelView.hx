package game.client.en.comp.view;

import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import h3d.scene.Object;
import game.net.client.GameClient;
import h3d.scene.Mesh;
import graphics.ThreeDObjectNode;

class EntityModelView implements IEntityView {

	final model : Object;
	final object : ThreeDObjectNode;

	public function new( file : String ) {
		model = GameClient.inst.modelCache.loadModel( hxd.Res.loader.load( file ).toModel() );
		object = ThreeDObjectNode.fromHeaps( model );
	}

	public function dispose() {
		model.remove();
	}

	public inline function provideSize( vec : ThreeDeeVector ) {
		object.heapsObject.scaleX = vec.x;
		object.heapsObject.scaleY = vec.y;
		object.heapsObject.scaleZ = vec.z;
	}

	public function getGraphics() : ThreeDObjectNode {
		return object;
	}

	public function addChildView( view : IEntityView ) {
		object.addChild( view.getGraphics() );
	}
}
