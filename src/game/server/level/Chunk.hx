package game.server.level;

import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import core.MutableProperty;
import game.client.level.ChunkView;
import en.Entity;
import net.NSArray;
import game.server.level.block.Block;
import net.NetNode;

class Chunk extends NetNode {

	public final blocks : Map<Int, Map<Int, Map<Int, Block>>>;

	@:s var entities : NSArray<Entity> = new NSArray();

	public var x : Int;
	public var y : Int;
	public var view : MutableProperty<ChunkView> = new MutableProperty();

	public function new( ?parent ) {
        super( parent );
		blocks = new Map();
	}

	override function alive() {
		view.val = new ChunkView();
		super.alive();
	}

	public inline function validateAccess( x : Int, y : Int, z : Int ) {
		if ( blocks[z] == null ) blocks[z] = new Map();
		if ( blocks[z][y] == null ) blocks[z][y] = new Map();
	}

	public inline function getBlock( x : Int, y : Int, z : Int ) : Block {
		validateAccess( x, y, z );
		return blocks[z][y][x];
	}

	public function setBlock( x : Int, y : Int, z : Int, block : Block ) {
		validateAccess( x, y, z );
		blocks[z][y][x] = block;
	}

	override function unregister(
		host : NetworkHost,
		ctx : NetworkSerializer,
		?finalize : Bool
	) {
		super.unregister( host, ctx, finalize );

		for ( blockZ in blocks ) {
			for ( blockY in blockZ ) {
				for ( blockX in blockY ) {
					blockX.unregister( host, ctx, finalize );
				}
			}
		}
	}
}
