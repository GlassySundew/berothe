package game.client.en.comp.view;

import haxe.exceptions.NotImplementedException;
import game.domain.overworld.location.physics.Types.Vec;
import h3d.scene.Object;
import game.net.client.GameClient;
import h3d.scene.Mesh;
import graphics.ObjectNode3D;

class EntityModelView implements IEntityView {

	final model : Object;
	final object : ObjectNode3D;

	public function new( file : String ) {
		model = GameClient.inst.modelCache.loadModel( hxd.Res.loader.load( file ).toModel() );
		object = ObjectNode3D.fromHeaps( model );
	}

	public function dispose() {
		model.remove();
	}

	public inline function provideSize( vec : Vec ) {
		object.heapsObject.scaleX = vec.x;
		object.heapsObject.scaleY = vec.y;
		object.heapsObject.scaleZ = vec.z;
	}

	public function getGraphics() : ObjectNode3D {
		return object;
	}

	public function addChildView( view : IEntityView ) {
		addChildObject( view.getGraphics() );
	}

	public function addChildObject( object : ObjectNode3D ) {
		this.object.addChild( object );
	}

	public function batcherize() {
		throw new NotImplementedException();
	}
}
