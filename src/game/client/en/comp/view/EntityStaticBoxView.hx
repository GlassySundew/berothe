package game.client.en.comp.view;

import haxe.exceptions.NotImplementedException;
import game.data.storage.entity.body.view.AnimationKey;
import core.MutableProperty;
import h3d.mat.Texture;
import h3d.mat.Material;
import h3d.scene.Mesh;
import h3d.prim.Cube;
import graphics.ThreeDObjectNode;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import h3d.scene.Object;

class EntityStaticBoxView implements IEntityView {

	final object : ThreeDObjectNode;
	final prim : Cube;

	public function new( size : ThreeDeeVector ) {
		prim = new Cube( size.x, size.y, size.z );
		prim.translate(-size.x / 2, -size.y / 2, -size.z / 2 );
		prim.unindex();
		prim.addNormals();
		prim.addUVs();
		prim.addUniformUVs( 1.0 );
		prim.addTangents();

		var mesh = new Mesh( prim, Material.create( Texture.fromColor( 0xffffff ) ) );
		mesh.material.mainPass.depth( true, LessEqual );

		object = ThreeDObjectNode.fromHeaps( mesh );
	}

	public inline function provideSize( vec : ThreeDeeVector ) {
		object.heapsObject.scaleX = vec.x;
		object.heapsObject.scaleY = vec.y;
		object.heapsObject.scaleZ = vec.z;
	}

	public function dispose() {
		object.remove();
	}

	public function getGraphics() : ThreeDObjectNode {
		return object;
	}

	public function addChildView( view : IEntityView ) {
		throw new NotImplementedException();
	}
}
