package game;

import util.Const;
import game.client.level.LevelView;
import game.server.level.block.GlobalBlocks;
import net.NetNode;
import oimo.dynamics.World;

class Level extends NetNode {

	@:s public final globalBlocks : GlobalBlocks;

	public var world( default, null ) : World;

	/** client **/
	public var levelView : LevelView;

	public function new( ?parent ) {
		super( parent );
		globalBlocks = new GlobalBlocks( this, this );
	}

	override function init() {
		super.init();
		world = new World( Const.worldGravity );
	}

	override function alive() {
		super.alive();
		levelView = new LevelView( this );
	}
}
