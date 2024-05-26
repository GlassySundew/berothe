package en.model;

import game.Level;
import core.MutableProperty;
import game.server.ServerLevelController;
import game.server.level.Chunk;
import net.NSMutableProperty;
import net.NetNode;
import util.Direction;
import en.collide.EntityContactCallback;

class EntityModel extends NetNode {

	public var isMovementApplied : Bool;

	@:s public var cdb : NSMutableProperty<Data.EntityBodyKind> = new NSMutableProperty( null );
	@:s public var dir : NSMutableProperty<Direction> = new NSMutableProperty( Bottom );
	@:s public var level : Level;

	public var chunk : MutableProperty<Chunk> = new MutableProperty( null );

	override function alive() {
		super.alive();
	}
}
