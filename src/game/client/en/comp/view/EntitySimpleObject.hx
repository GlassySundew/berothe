package game.client.en.comp.view;

import h3d.prim.Cube;
import h3d.scene.Object;
import game.domain.overworld.location.physics.Types.Vec;
import graphics.ObjectNode3D;

class EntitySimpleObject implements IEntityView {

	final object : ObjectNode3D;

	public function new() {
		object = ObjectNode3D.fromHeaps( new Object() );
	}

	public function dispose() {
		object.remove();
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

	public function provideSize( vec : Vec ) {}

	public function batcherize() {}
}
