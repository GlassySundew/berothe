package game.core.rules.overworld.location.physics;

interface IShapeConfig {

	var geom( default, null ) : IGeometry;
	function setGeometry( geom : IGeometry ) : Void;
}