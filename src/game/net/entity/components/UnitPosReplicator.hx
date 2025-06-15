package game.net.entity.components;

import net.NetNode;

class UnitPosReplicator extends NetNode {

	@:s public var x : Float;
	@:s public var y : Float;
	@:s public var z : Float;

	public function new(?p) {
		super(p);
	}
}