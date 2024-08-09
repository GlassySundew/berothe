package game.physics.oimo;

import oimo.collision.geometry.BoxGeometry;
import game.core.rules.overworld.location.physics.ITransform;
import game.core.rules.overworld.location.physics.ITransformProvider;
import game.core.rules.overworld.location.physics.IGeometry;
import game.core.rules.overworld.location.physics.Types.ThreeDeeVector;
import en.collide.RayCastCallback;
import oimo.dynamics.rigidbody.Shape;
import oimo.common.Vec3;
import game.debug.HeapsOimophysicsDebugDraw;
import oimo.dynamics.common.DebugDraw;
import game.core.rules.overworld.location.physics.IDebugDraw;
import game.physics.oimo.OimoRigidBody;
import util.Assert;
import game.core.rules.overworld.location.physics.IRigidBody;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import oimo.dynamics.rigidbody.RigidBody;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import oimo.dynamics.World;

class OimoPhysicsEngine implements IPhysicsEngine {

	var world : World = new World();
	var debugDraw : HeapsOimophysicsDebugDraw;

	var shapes : Map<Int, OimoRigidBodyShape> = [];

	public inline function new() {
		world.setGravity( new Vec3( 0, 0, -9.8 ) );
	}

	public function update( dt : Float ) {
		world.step( dt );

		if ( debugDraw != null && debugDraw.graphics.visible ) {
			Std.downcast( debugDraw, HeapsOimophysicsDebugDraw ).graphics.clear();
			inline world.debugDraw();
		}
	}

	public function addRigidBody( rigidBody : IRigidBody ) {
		Assert.isOfType( rigidBody, OimoRigidBody );
		world.addRigidBody( Std.downcast( rigidBody, OimoRigidBody ).rigidBody );
	}

	public function setDebugDraw( debugDraw : IDebugDraw ) {
		Assert.isNull( this.debugDraw );
		Assert.isOfType( debugDraw, DebugDraw );
		this.debugDraw = Std.downcast( debugDraw, HeapsOimophysicsDebugDraw );

		world.setDebugDraw( this.debugDraw );
	}

	// public function getShapeByOimo( shape : Shape ) : IRigidBodyShape {
	// 	if ( shape._id == -1 )
	// 		throw "trying to get unattached shape with id = -1, don't know how to handle";
	// 	var result : IRigidBodyShape = null;
	// 	var savedShape = shapes[shape._id];
	// 	if ( savedShape == null ) {
	// 		result = ShapeAbstractFactory.fromShape( shape );
	// 	} else {
	// 		result = savedShape;
	// 	}
	// 	return result;
	// }

	public inline function rayCast( begin : ThreeDeeVector, end : ThreeDeeVector, callback : RayCastCallback ) {
		world.rayCast( begin.toOimo(), end.toOimo(), callback );

		#if client
		debugDraw.line( begin, end, ThreeDeeVector.fromColorF( 0xBA8200 ).toOimo() );
		#end
	}

	public function convexCast(
		convex : IGeometry,
		start : ITransform,
		translation : ThreeDeeVector,
		callback : RayCastCallback
	) {
		#if debug
		Assert.isOfType( convex, OimoGeometry );
		#end

		var geom = Std.downcast( convex, OimoGeometry ).geom;
		var beginTransform = Std.downcast( start, OimoTransform ).transform;

		world.convexCast(
			geom,
			beginTransform,
			translation.toOimo(),
			callback
		);

		#if client
		var beginPoint = beginTransform.getPosition();
		debugDraw.line( beginPoint, beginPoint.addScaled( translation, callback.fraction ), ThreeDeeVector.fromColorF( 0x23DB20 ) );
		beginTransform.setPosition( beginTransform.getPosition().addScaledEq( translation, callback.fraction ) );
		debugDraw.point( callback.position, ThreeDeeVector.fromColorF( 0xB224A1 ) );
		
		switch Type.getClass( geom ) {
			case BoxGeometry:
				var box = Std.downcast(geom, BoxGeometry);
				debugDraw.box( beginTransform, box.getHalfExtents(), ThreeDeeVector.fromColorF( 0x185ED0 ).toOimo() );

			case e: throw e + " geometry is not supported in debugdraw";
		}
		#end
	}
}
