package game.client;

import core.MutableProperty;
import dn.Process;
import dn.heaps.input.ControllerAccess;
import en.Entity;
import en.player.Player;
import h3d.scene.CameraController;
import h3d.scene.Object;
import net.Client;
import ui.PauseMenu;
import util.Const;
import util.Settings;
import util.threeD.CameraProcess;
import game.client.level.LevelView;


/**
	Логика игры на клиете
**/
class GameClient extends Process {

	public static var inst : GameClient;

	public var cameraProc : CameraProcess;
	public var levelView : MutableProperty<LevelView> = new MutableProperty();
	public var player : en.player.Player;
	public var suspended : Bool = false;
	public var navFieldsGenerated : Null<Int>;

	var ca : ControllerAccess<ControllerAction>;
	private var cam : CameraController;

	#if game_tmod
	var stats : h2d.Text;
	#end

	public function new() {
		super( Main.inst );

		inst = this;

		ca = Main.inst.controller.createAccess();

		#if game_tmod
		stats = new Text( Assets.fontPixel, Boot.inst.s2d );
		#end

		createRootInLayers( Main.inst.root, Const.DP_BG );

		cameraProc = new CameraProcess( this );
		cameraProc.doRound = false;

		Client.inst.onConnectionClosed.add( destroy ).repeat( 1 );
	}

	public function onCdbReload() {}

	public function restartLevel() {
		// startLevel(lvlName);
	}

	public function startLevelFromTmx( name : String ) {
		// this.tmxMap = tmxMap;
		// engine.clear( 0, 1 );

		// if ( level != null ) {
		// 	level.destroy();
		// 	gc();
		// }
		// level = new Level( tmxMap );

		// hideStrTiles();

		// onLevelChanged.dispatch();

		// return level;
	}

	public function gc() {
		if ( Entity.GC == null || Entity.GC.length == 0 ) return;

		for ( e in Entity.GC ) e.dispose();
		Entity.GC = [];
	}

	override function onDispose() {
		super.onDispose();

		Settings.inst.saveSettings();

		inst = null;

		#if game_tmod
		if ( stats != null ) stats.remove();
		#end

		if ( cameraProc != null ) cameraProc.destroy();

		for ( e in Entity.ALL.copy() ) {
			e.dispose();
		}
		gc();

		Client.inst.disconnect();

		ca.dispose();
	}

	override function update() {
		super.update();

		#if game_tmod
		stats.text = "tmod: " + tmod;
		#end

		// Updates

		for ( e in Entity.ALL ) if ( !e.isDestroyed ) e.preUpdate();
		for ( e in Entity.ALL ) if ( !e.isDestroyed ) e.update();

		if ( levelView.val != null ) {
			levelView.val.physics.step( Boot.inst.deltaTime );
		}

		for ( e in Entity.ALL ) if ( !e.isDestroyed ) e.postUpdate();
		for ( e in Entity.ALL ) if ( !e.isDestroyed ) e.frameEnd();

		gc();

		if ( ca.isPressed( Escape ) ) {
			new PauseMenu( this, Main.inst.root, Main.inst );
		}
	}

	override function pause() {
		super.pause();
	}

	override function resume() {
		super.resume();
	}
}

// debug stuff
class AxesHelper extends h3d.scene.Graphics {

	public function new( ?parent : h3d.scene.Object, size = 2.0, colorX = 0xEB304D, colorY = 0x7FC309, colorZ = 0x288DF9, lineWidth = 2.0 ) {
		super( parent );

		material.props = h3d.mat.MaterialSetup.current.getDefaults( "ui" );

		lineShader.width = lineWidth;

		setColor( colorX );
		lineTo( size, 0, 0 );

		setColor( colorY );
		moveTo( 0, 0, 0 );
		lineTo( 0, size, 0 );

		setColor( colorZ );
		moveTo( 0, 0, 0 );
		lineTo( 0, 0, size );
	}
}
class GridHelper extends h3d.scene.Graphics {

	public function new( ?parent : Object, size = 10.0, divisions = 10, color1 = 0x444444, color2 = 0x888888, lineWidth = 1.0 ) {
		super( parent );

		material.props = h3d.mat.MaterialSetup.current.getDefaults( "ui" );

		lineShader.width = lineWidth;

		var hsize = size / 2;
		var csize = size / divisions;
		var center = divisions / 2;
		for ( i in 0...divisions + 1 ) {
			var p = i * csize;
			setColor(( i != 0 && i != divisions && i % center == 0 ) ? color2 : color1 );
			moveTo(-hsize + p, -hsize, 0 );
			lineTo(-hsize + p, -hsize + size, 0 );
			moveTo(-hsize, -hsize + p, 0 );
			lineTo(-hsize + size, -hsize + p, 0 );
		}
	}
}
