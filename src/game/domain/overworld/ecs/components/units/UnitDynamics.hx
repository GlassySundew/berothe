package game.domain.overworld.ecs.components.units;

@:struct @:structInit
class UnitPlacedInChunkEvent {}

@:struct
@:structInit
class UnitChunk {

	public var x : Int;
	public var y : Int;
	public var z : Int;
}

@:struct
@:structInit
class UnitPosition {

	public var x : Float;
	public var y : Float;
	public var z : Float;
}

@:struct
@:structInit
class UnitVelocity {

	public var x : Float;
	public var y : Float;
	public var z : Float;
}

typedef MovedThisTick = Bool;
