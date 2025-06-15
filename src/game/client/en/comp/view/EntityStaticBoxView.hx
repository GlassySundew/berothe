package game.client.en.comp.view;

import haxe.exceptions.NotImplementedException;
import game.data.storage.entity.body.view.AnimationKey;
import core.MutableProperty;
import h3d.mat.Texture;
import h3d.mat.Material;
import h3d.scene.Mesh;
import h3d.prim.Cube;
import graphics.ObjectNode3D;
import game.domain.overworld.location.physics.Types.Vec;
import h3d.scene.Object;

class EntityStaticBoxView implements IEntityView {

	final object : ObjectNode3D;
	final prim : Cube;

	public function new( size : Vec ) {
		prim = new Cube();
		prim.translate( -.5, -.5, -.5 );
		prim.unindex();
		prim.addNormals();
		prim.addUVs();
		prim.addUniformUVs( 1.0 );
		prim.addTangents();

		var mesh = new Mesh( prim, Material.create( Texture.fromColor( 0xffffff ) ) );
		mesh.material.mainPass.depth( true, LessEqual );

		object = ObjectNode3D.fromHeaps( mesh );
	}

	public inline function provideSize( vec : Vec ) {
		object.heapsObject.scaleX = vec.x;
		object.heapsObject.scaleY = vec.y;
		object.heapsObject.scaleZ = vec.z;
	}

	public function dispose() {
		object.remove();
	}

	public function getGraphics() : ObjectNode3D {
		return object;
	}

	public function addChildView( view : IEntityView ) {
		throw new NotImplementedException();
	}

	public function addChildObject( object : ObjectNode3D ) {
		throw new NotImplementedException();
	}

	public function batcherize() {
		throw new NotImplementedException();
	}
}
