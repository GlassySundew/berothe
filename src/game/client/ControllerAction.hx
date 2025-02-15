package game.client;

enum abstract ControllerAction(Int) to Int {
	var MOVE_UP;
	var MOVE_UP_RIGHT;
	var MOVE_RIGHT;
	var MOVE_DOWN_RIGHT;
	var MOVE_DOWN;
	var MOVE_DOWN_LEFT;
	var MOVE_LEFT;
	var MOVE_UP_LEFT;

	var ACTION;
	var DROP_ITEM;
	var TOGGLE_INVENTORY;
	var ATTACK;
}

enum abstract EscapeAction(Int) to Int {
	var ESCAPE;
}