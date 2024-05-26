package game.server.level.block;

import net.NSMutableProperty;
import net.NSArray;
import net.NetRootNode;

class GlobalBlocks extends NetRootNode {

	// global chunk of blocks;
	@:s private final blocks : NSArray<Block> = new NSArray();

	var level : Level;

	public function new( level : Level, ?parent ) {
		super( parent );
		this.level = level;
	}

	public function addBlock( block : Block ) {
		trace('adding block');
		block.level.val = level;
		blocks.push( block );
	}
}
