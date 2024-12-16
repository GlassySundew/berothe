package game.domain.overworld.entity;

import util.MathUtil;
import dn.M;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import signals.Signal;
import core.MutableProperty;

class EntityTransform {

	public final x = new MutableProperty( 0. );
	public final y = new MutableProperty( 0. );
	public final z = new MutableProperty( 0. );

	public final velX = new MutableProperty( 0. );
	public final velY = new MutableProperty( 0. );
	public final velZ = new MutableProperty( 0. );

	public final rotationX = new MutableProperty( 0. );
	public final rotationY = new MutableProperty( 0. );
	public final rotationZ = new MutableProperty( 0. );

	public final onTakeControl = new Signal();
	public final onReleaseControl = new Signal();

	public function new() {}

	#if !debug inline #end
	public function distToEntity2D( entity : OverworldEntity ) : Float {
		return M.dist( x.val, y.val, entity.transform.x.val, entity.transform.y.val );
	}

	#if !debug inline #end
	public function distToEntity3D( entity : OverworldEntity ) : Float {
		return
			MathUtil.dist3(
				x.val, y.val, z.val,
				entity.transform.x.val, entity.transform.y.val, entity.transform.z.val
			);
	}

	#if !debug inline #end
	public function turnTowardsTo( entity : OverworldEntity ) {
		var dx = entity.transform.x.val - x.val;
		var dy = entity.transform.y.val - y.val;
		var angle = Math.atan2( dy, dx );
		rotationZ.val = angle;
	}

	#if !debug inline #end
	public function turnAwayFrom( entity : OverworldEntity ) {
		var dx = entity.transform.x.val - x.val;
		var dy = entity.transform.y.val - y.val;
		var angle = Math.atan2( dy, dx ) - M.toRad( 180 );
		rotationZ.val = angle;
	}

	#if !debug inline #end
	public function getPosition() : ThreeDeeVector {
		return {
			x : x.val,
			y : y.val,
			z : z.val
		}
	}

	#if !debug inline #end
	public function setPosition( x : Float, y : Float, z : Float ) {
		// onTakeControl.dispatch();
		this.x.val = x;
		this.y.val = y;
		this.z.val = z;
		// onReleaseControl.dispatch();
	}

	#if !debug inline #end
	public function setVelocity( x : Float, y : Float, z : Float ) {
		// onTakeControl.dispatch();
		this.velX.val = x;
		this.velY.val = y;
		this.velZ.val = z;
		// onReleaseControl.dispatch();
	}

	#if !debug inline #end
	public function getRotation() : ThreeDeeVector {
		return {
			x : rotationX.val,
			y : rotationY.val,
			z : rotationZ.val
		}
	}

	#if !debug inline #end
	public function setRotation( x : Float, y : Float, z : Float ) {
		// onTakeControl.dispatch();
		this.rotationX.val = x;
		this.rotationY.val = y;
		this.rotationZ.val = z;
		// onReleaseControl.dispatch();
	}

	@:keep
	public function toString() : String {
		return "EntityTransform: x : " + x.val + ", y : " + y.val + ", z : " + z.val + ";";
	}
}
