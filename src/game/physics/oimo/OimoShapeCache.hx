package game.physics.oimo;

import util.Assert;
import be.Constant.Ints;

class OimoShapeCache {

	static var SHAPE_CACHE : Map<Int, OimoRigidBodyShape> = [];
	static var OIMO_SHAPE_ID_INC = Ints.MIN;

	public inline static function provideShape( shape : OimoRigidBodyShape ) {

		shape.shape.cacheIdSelf = OIMO_SHAPE_ID_INC++;

		Assert.isNull( SHAPE_CACHE[shape.shape.cacheIdSelf] );

		SHAPE_CACHE[shape.shape.cacheIdSelf] = shape;
	}

	public inline static function getShape( id : Int ) : OimoRigidBodyShape {
		Assert.notNull( SHAPE_CACHE[id] );

		return SHAPE_CACHE[id];
	}

	public inline static function removeShape( shape : OimoRigidBodyShape ) {
		SHAPE_CACHE.remove( shape.shape.cacheIdSelf );
	}
}
