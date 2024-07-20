package game.physics.oimo;

import util.Assert;
import oimo.dynamics.rigidbody.ShapeConfig;
import game.core.rules.overworld.location.physics.IGeometry;
import game.core.rules.overworld.location.physics.IShapeConfig;

class OimoShapeConfig implements IShapeConfig {

	public var geom( default, null ) : IGeometry;
	public final config : ShapeConfig;

	public function new( config : ShapeConfig ) {
		this.config = config;
	}

	public function setGeometry( geom : IGeometry ) {
		this.geom = geom;

		Assert.isOfType( geom, OimoGeometry );

		config.geometry = Std.downcast( geom, OimoGeometry ).geom;
	}
}
