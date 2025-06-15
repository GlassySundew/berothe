package game.domain.overworld.location.physics;

import game.domain.overworld.location.physics.Types.Vec;

interface IDebugDraw {

	function remove() : Void;
	function setVisibility( value : Bool ) : Void;
	function point( v : Vec, color : Vec ) : Void;
	function triangle(
		v1 : Vec,
		v2 : Vec,
		v3 : Vec,
		n1 : Vec,
		n2 : Vec,
		n3 : Vec,
		color : Vec
	) : Void;
	function line(
		v1 : Vec,
		v2 : Vec,
		color : Vec
	) : Void;
	function update() : Void;
}
