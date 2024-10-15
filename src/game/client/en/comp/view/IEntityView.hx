package game.client.en.comp.view;

import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import graphics.ObjectNode3D;

interface IEntityView {

	function dispose() : Void;
	function getGraphics() : ObjectNode3D;
	function addChildView( view : IEntityView ) : Void;
	function addChildObject( object : ObjectNode3D ) : Void;
	function provideSize( vec : ThreeDeeVector ) : Void;
}
