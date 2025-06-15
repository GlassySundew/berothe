package game.domain;

enum abstract SystemPriority(Int) to Int {

	var CORE = 10;
	var NETWORK = 9;

	var DISPOSAL = 0;
}