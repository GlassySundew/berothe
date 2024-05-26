package game.server.level.block;

import net.NSMutableProperty;
import game.client.level.LevelView;
import net.NSArray;
import oimo.dynamics.World;
import game.client.level.BlockView;
import net.NetNode;

abstract class Block extends NetNode {

	@:s public var x : Float;
	@:s public var y : Float;
	@:s public var z : Float;

	public var view : BlockView;

	@:s public var level : NSMutableProperty<Level>;

	public function new( ?parent : NetNode ) {
		level = new NSMutableProperty( null );
		super( parent );
	}

	override function init() {
		super.init();

	}

	override function alive() {
		super.alive();
		createPhysics();
		createView();
	}

	abstract public function createView() : Void;

	/**
		basically an init function, called when all required parameters are 
		parsed and set
	**/
	public function createPhysics() {
		level.onAppear( attachPhysics );
	}

	abstract public function attachPhysics( level : Level ) : Void;
}
