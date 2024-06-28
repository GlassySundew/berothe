package game.client.level;

import game.client.level.physics.ClientPhysics;
import util.tools.Settings;
import game.client.debug.HeapsOimophysicsDebugDraw;
import dn.Process;
import h3d.scene.Interactive;
import h3d.scene.Object;
import oimo.dynamics.World;
import game.client.level.batch.LUTBatcher;

/**
	client-side level rendering
**/
class LevelView extends dn.Process {

	public static var inst( default, null ) : LevelView;

	public var lvlName : String;

	/**
		3d x coord of cursor
	**/
	public var cursX : Float;

	/**
		3d y coord of cursor
	**/
	public var cursY : Float;

	public var tilesetCache : TilesetCache = new TilesetCache();
	public var batcher : LUTBatcher;
	public var root3d : Object;

	// public final level : Level;

	// public final physics : ClientPhysics;
	var physicsDebugView : HeapsOimophysicsDebugDraw;


	// public function new( level : Level ) {
	// 	super( GameClient.inst );
	// 	this.level = level;
	// 	inst = this;
	// 	root3d = new Object( Boot.inst.s3d );
	// 	batcher = new LUTBatcher();

	// 	// GameClient.inst.levelView.val = this;

	// 	physics = new ClientPhysics( level.world );

	// 	#if debug
	// 	debugInit();
	// 	#end
	// }

	override function onDispose() {
		super.onDispose();
		root3d.remove();
		inst = null;
	}

	override function preUpdate() {
		super.preUpdate();
	}

	override function update() {
		super.update();
		inline batcher.emitAll();
	}

	override function postUpdate() {
		super.postUpdate();
	}

	// function debugInit() {
	// 	physics.debugInit();
	// }
}
