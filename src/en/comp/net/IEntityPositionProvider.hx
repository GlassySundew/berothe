package en.comp.net;

import h3d.Vector;

interface IEntityPositionProvider {

	var velX( get, set ) : Float;
	var velY( get, set ) : Float;
	var velZ( get, set ) : Float;

	function getEntityPosition() : Vector;
	function update() : Void;
}
