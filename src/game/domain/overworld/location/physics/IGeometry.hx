package game.domain.overworld.location.physics;

import oimo.common.Mat3;

interface IGeometry {

	function setVolume( value : Float ) : Void;
	function getIntertiaCoeff() : Mat3;
}
