package game.data.storage.entity.body.view;

import h3d.mat.Texture;
import h3d.mat.Material;
import h3d.scene.Mesh;
import h3d.prim.Cube;
import graphics.ThreeDObjectNode;
import game.data.storage.entity.body.view.IEntityView.EntityViewInitializationSetting;

class StaticObjectGrayboxViewDescription implements IEntityView {

	public function new() {}

	public function createView( setting : EntityViewInitializationSetting ) : ThreeDObjectNode {
		var view = switch setting {
			case Size( x, y, z ):
				createCubeOfSize( x, y, z );
			case e:
				throw "graybox required setting Size, got: " + e;
		}

		// view.

		return view;
	}

	function createCubeOfSize( x : Float, y : Float, z : Float ) {
		var prim = new Cube( x, y, z );
		prim.translate( -x / 2, -y / 2, -z / 2 );
		prim.unindex();
		prim.addNormals();
		prim.addUVs();
		prim.addUniformUVs( 1.0 );
		prim.addTangents();

		var mesh = new Mesh( prim, Material.create( Texture.fromColor( 0xffffff ) ) );
		mesh.material.mainPass.depth( true, LessEqual );

		return ThreeDObjectNode.fromHeapsObject( mesh );
	}

	function defaultCube( x, y, z ) {
		// var engine = h3d.Engine.getCurrent();
		// var c : Cube = @:privateAccess engine.resCache.get( Cube );
		// if ( c != null )
		// 	return c;
		// c = new h3d.prim.Cube( x, y, z );
		// c.translate( , -0.5, -0.5 );
		// c.unindex();
		// c.addNormals();
		// c.addUniformUVs( 1.0 );
		// c.addTangents();
		// @:privateAccess engine.resCache.set( Cube, c );
		// return c;
	}
}
