package game.net.client;

import rx.disposables.Composite;
import domkit.Component;
import haxe.EnumFlags;
import future.Future;
import h3d.scene.Mesh;
import hxd.Res;
import graphics.BatchRenderer;
import h3d.scene.pbr.DirLight;
import util.threeD.ModelCache;
#if client
import ui.dialog.ConnectMenu;
import signals.Signal;
import net.NetNode;
import hxbit.NetworkSerializable;
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
import game.client.ControllerAction;
import game.data.storage.DataStorage;
import game.debug.HeapsOimophysicsDebugDraw;
import game.domain.overworld.GameCore;
import game.domain.overworld.location.Location;
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

	final currentLocationSelf : MutableProperty<Location> = new MutableProperty();
	public var currentLocation( get, never ) : IProperty<Location>;
	inline function get_currentLocation() : IProperty<Location> {
		return currentLocationSelf;
	}

	public final onUpdate : Signal = new Signal();
	public final core : GameCore = new GameCore();
	public final controlledEntity : MutableProperty<EntityReplicator> = new MutableProperty();
	public final cameraProc : CameraProcess;
	public final modelCache : ModelCache = new ModelCache();
	public final disposed = new Future();

	final subscription = Composite.create();

	var locationLights : DirLight;
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

		subscription.add( Client.inst.onUnregister.add( onUnregister ) );

		currentLocationSelf.addOnValue( ( oldLoc, newLoc ) -> {
			if ( oldLoc != null ) {
				oldLoc.removeEntity( controlledEntity.getValue().entity.result );
				oldLoc.dispose();
				oldLoc.update( 0, 0 );
				#if debug
				oldLoc.physics.getDebugDraw()?.remove();
				#end
			}

			if ( newLoc == null ) return;

			if ( newLoc.locationDesc.isOpenAir ) {
				locationLights?.remove();
				locationLights = new DirLight( new h3d.Vector( -0.7, -0.2, -1 ), Boot.inst.s3d );
				locationLights.power = 1;
				locationLights.shadows.mode = Dynamic;
				locationLights.shadows.blur.radius = 0.2;
				locationLights.shadows.bias = 0.02;
			} else {
				locationLights?.remove();
				locationLights = null;
			}
		} );
		new graphics.BatchRenderer( Boot.inst.s3d );
	}

	public function onLocationProvided( locationDescId : String ) {
		controlledEntity.onAppear( ( playerRepl ) -> {
			currentLocationSelf.val = core.getOrCreateLocationByDesc(
				DataStorage.inst.locationStorage.getById(
					locationDescId
				),
				playerRepl.entity.result
			);

			#if debug debugDraw(); #end
		} );
	}

	#if( client && debug )
	function debugDraw() {
		var physicsDebugView = new HeapsOimophysicsDebugDraw( Boot.inst.s3d );
		currentLocationSelf.val.physics.setDebugDraw( physicsDebugView );
		physicsDebugView.setVisibility( Settings.inst.params.debug.physicsDebugVisible );

		Settings.inst.params.debug.physicsDebugVisible.addOnValue(
			( oldVal, value ) -> physicsDebugView.setVisibility( value )
		);
	}
	#end

	override function onDispose() {
		super.onDispose();

		Settings.inst.saveSettings();

		if ( cameraProc != null ) cameraProc.destroy();

		Client.inst.disconnect();

		ca.dispose();

		currentLocationSelf.val = null;
		controlledEntity.getValue()?.entity.result?.dispose();
		subscription.unsubscribe();

		disposed.resolve( true );
		inst = null;
	}

	override function update() {
		super.update();
		currentLocationSelf.val?.physics.getDebugDraw()?.update();

		if ( ca.isPressed( Escape ) ) {
			new PauseMenu( this, Main.inst.root, Main.inst );
		}

		currentLocationSelf.val?.update( hxd.Timer.dt, tmod );
		onUpdate.dispatch();

		BatchRenderer.inst?.emitBatches();
	}

	override function pause() {
		super.pause();
	}

	override function resume() {
		super.resume();
	}

	function onUnregister( o : NetworkSerializable ) {
		Std.downcast( o, NetNode )?.onUnregisteredClient();
	}
}

#if debug
class AxesHelper extends h3d.scene.Graphics {

	public function new( ?parent : h3d.scene.Object, size = 2.0, colorX = 0xEB304D, colorY = 0x7FC309, colorZ = 0x288DF9, lineWidth = 2.0 ) {
		super( parent );

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
