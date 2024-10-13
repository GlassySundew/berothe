package game.client.en.comp.view;

import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import graphics.ThreeDObjectNode;

interface IEntityView {

	function dispose() : Void;
	function getGraphics() : ThreeDObjectNode;
	function addChildView( view : IEntityView ) : Void;
	function provideSize( vec : ThreeDeeVector ) : Void;
}
