package game.net.client;

import game.client.ControllerAction;
#if client
import game.debug.HeapsOimophysicsDebugDraw;
import core.IProperty;
import core.MutableProperty;
import dn.Process;
import dn.heaps.input.ControllerAccess;
import h3d.scene.CameraController;
import h3d.scene.Object;
import net.Client;
import ui.PauseMenu;
import util.Const;
import util.Settings;
import util.threeD.CameraProcess;
import game.core.rules.overworld.location.Location;
import game.data.storage.DataStorage;
import game.net.entity.EntityReplicator;
import game.net.location.LocationReplicator;

/**
	Логика игры на клиете
**/
class GameClient extends Process {

	public static var inst( default, set ) : GameClient;
	static function set_inst( game : GameClient ) {
		if ( inst != null ) {
			inst.destroy();
			@:privateAccess Process._garbageCollector( Process.ROOTS );
		}
		return inst = game;
	}

	public var cameraProc : CameraProcess;

	public var controlledEntity( default, null ) : EntityReplicator;

	final currentLocationSelf : MutableProperty<Location> = new MutableProperty();
	public var currentLocation( get, never ) : IProperty<Location>;
	inline function get_currentLocation() : IProperty<Location> {
		return currentLocationSelf;
	}

	var ca : ControllerAccess<ControllerAction>;
	var cam : CameraController;

	public function new() {
		super( Main.inst );

		#if debug
		// new AxesHelper( Boot.inst.s3d );
		// new GridHelper( Boot.inst.s3d );
		#end

		inst = this;
		ca = Main.inst.controller.createAccess();

		createRootInLayers( Main.inst.root, Const.DP_BG );

		cameraProc = new CameraProcess( this );
		cameraProc.doRound = false;

		Client.inst.onConnectionClosed.add( destroy );
		Client.inst.onConnectionClosed.repeat( 1 );
	}

	override function onDispose() {
		super.onDispose();

		Settings.inst.saveSettings();

		inst = null;

		if ( cameraProc != null ) cameraProc.destroy();

		Client.inst.disconnect();

		ca.dispose();
	}

	override function update() {
		super.update();

		if ( ca.isPressed( Escape ) ) {
			new PauseMenu( this, Main.inst.root, Main.inst );
		}

		currentLocationSelf.val?.update( tmod / hxd.Timer.wantedFPS, tmod );
	}

	override function pause() {
		super.pause();
	}

	override function resume() {
		super.resume();
	}

	public function onLocationProvided( locationRepl : LocationReplicator ) {
		currentLocationSelf.val = new Location(
			DataStorage.inst.locationStorage.getDescriptionById(
				locationRepl.locationDescriptionId
			),
			'0'
		);

		var physicsDebugView = new HeapsOimophysicsDebugDraw( Boot.inst.s3d );
		currentLocationSelf.val.physics.setDebugDraw( physicsDebugView );
		physicsDebugView.setVisibility( Settings.inst.params.debug.physicsDebugVisible );

		Settings.inst.params.debug.physicsDebugVisible.addOnValue(
			( oldVal, value ) -> physicsDebugView.setVisibility( value )
		);
	}
}

#if debug
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
#end
#end
