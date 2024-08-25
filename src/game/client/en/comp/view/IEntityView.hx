package game.client.en.comp.view;

import graphics.ThreeDObjectNode;

interface IEntityView {

	function dispose() : Void;
	function getGraphics() : ThreeDObjectNode;
}
