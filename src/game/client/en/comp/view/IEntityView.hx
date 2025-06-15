package game.client.en.comp.view;

import game.domain.overworld.location.physics.Types.Vec;
import graphics.ObjectNode3D;

interface IEntityView {

	function dispose() : Void;
	function getGraphics() : ObjectNode3D;
	function addChildView( view : IEntityView ) : Void;
	function addChildObject( object : ObjectNode3D ) : Void;
	function provideSize( vec : Vec ) : Void;
	function batcherize() : Void;
}
