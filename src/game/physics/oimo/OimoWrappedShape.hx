package game.physics.oimo;

import game.domain.overworld.location.physics.IShapeConfig;
import util.Assert;
import oimo.dynamics.rigidbody.Shape;

class OimoWrappedShape extends Shape {

	@:allow( game.physics.oimo.OimoShapeCache )
	var cacheIdSelf : Int;
	public var cacheId( get, never ) : Int;
	inline function get_cacheId() : Int {
		return cacheIdSelf;
	}

	public final config : IShapeConfig;

	public function new( config : IShapeConfig ) {
		super( Std.downcast( config, OimoShapeConfig ).config );
		this.config = config;
	}
}
