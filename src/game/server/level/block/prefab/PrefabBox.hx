package game.server.level.block.prefab;

import util.Const;
import oimo.dynamics.rigidbody.RigidBody;
import game.server.level.prefab.mediator.IPrefabObject;
import hrt.prefab.l3d.Box;
import h3d.scene.Mesh;
import hxd.Math;
import oimo.common.Vec3;
import oimo.dynamics.World;
import util.oimo.OimoUtil;

class PrefabBox extends Prefab3DObject {

	@:s public var isCollidable : Bool;

	/** client-side **/
	var mesh : Mesh;

	var rigidBody : RigidBody;

	function createView() {
		if ( !isVisible ) return;

		mesh = new h3d.scene.Mesh( h3d.prim.Cube.defaultUnitCube(), Boot.inst.s3d );
		mesh.x = x;
		mesh.y = y;
		mesh.z = z;
		mesh.scaleX = scaleX;
		mesh.scaleY = scaleY;
		mesh.scaleZ = scaleZ;
		mesh.setRotation( Math.degToRad( rotationX ), Math.degToRad( rotationY ), Math.degToRad( rotationZ ) );
		// mesh.material.shadows = false;
	}

	public function attachPhysics( level : Level ) {
		if ( rigidBody == null ) return;
		level.world.addRigidBody( rigidBody );
	}

	override function createPhysics() {

		if ( !isCollidable ) return;

		rigidBody = OimoUtil.addBox(
			new Vec3(
				scaleX / 2,
				scaleY / 2,
				scaleZ / 2
			), new Vec3(
				scaleX / 2,
				scaleY / 2,
				scaleZ / 2
			), true
		);
		var shape = rigidBody.getShapeList();
		shape.setCollisionGroup( Const.G_PHYSICS );
		shape.setCollisionMask( Const.G_PHYSICS );
		rigidBody.setPosition( new Vec3( x, y, z ) );

		super.createPhysics();
	}
}
