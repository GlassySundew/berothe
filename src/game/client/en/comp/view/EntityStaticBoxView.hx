package game.client.en.comp.view;

import game.data.storage.entity.body.view.AnimationKey;
import core.MutableProperty;
import h3d.mat.Texture;
import h3d.mat.Material;
import h3d.scene.Mesh;
import h3d.prim.Cube;
import graphics.ThreeDObjectNode;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import h3d.scene.Object;

class EntityStaticBoxView implements IEntityView {

	final object : ThreeDObjectNode;

	public function new( size : ThreeDeeVector ) {
		var prim = new Cube( size.x, size.y, size.z );
		prim.translate(-size.x / 2, -size.y / 2, -size.z / 2 );
		prim.unindex();
		prim.addNormals();
		prim.addUVs();
		prim.addUniformUVs( 1.0 );
		prim.addTangents();

		var mesh = new Mesh( prim, Material.create( Texture.fromColor( 0xffffff ) ) );
		mesh.material.mainPass.depth( true, LessEqual );

		object = ThreeDObjectNode.fromHeapsObject( mesh );
	}

	public function getGraphics() : ThreeDObjectNode {
		return object;
	}
}