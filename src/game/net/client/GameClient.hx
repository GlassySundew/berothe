package game.net.client;

import pass.PbrSetup.PbrRenderer;
import dn.Delayer;
import game.net.entity.component.EntityModelComponentReplicator;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import ui.Console;
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

	var locationLights : hrt.prefab.Prefab;
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
			locationLights?.findFirstLocal3d().remove();
			locationLights = null;

			if ( oldLoc != null ) {
				if ( !controlledEntity.getValue().entity.result?.disposed.isTriggered )
					oldLoc.removeEntity( controlledEntity.getValue().entity.result );
				#if debug
				oldLoc.physics.getDebugDraw()?.remove();
				#end
				oldLoc.dispose();
			}

			if ( newLoc == null ) return;

			Std.downcast(Boot.inst.s3d.renderer, PbrRenderer).env.power = newLoc.locationDesc.isOpenAir ? 0.7 : 0.4;
			
			if ( newLoc.locationDesc.isOpenAir ) {
				locationLights?.findFirstLocal3d().remove();
				locationLights = Res.levels.light.load().make();
				Boot.inst.s3d.addChild( locationLights.findFirstLocal3d() );
			}

			Boot.inst.s3d.visible = false;
			delayer.addF(() -> {
				Boot.inst.s3d.visible = true;
			}, 5 );
		} );
	}

	public function consoleSay( text : String ) {
		Main.inst.console.log( text );
	}

	public function onLocationProvided( locationDescId : String ) {
		trace( "LOCATION PROVIDED: " + locationDescId );

		controlledEntity.onAppear( ( playerRepl ) -> {
			new graphics.BatchRenderer( Boot.inst.s3d );
			currentLocationSelf.val = core.getOrCreateLocationByDesc(
				DataStorage.inst.locationStorage.getById(
					locationDescId
				),
				playerRepl.entity.result
			);

			#if debug debugDraw(); #end
		} );
	}

	public function setFriendly() {
		var modelRepl = controlledEntity.getValue()?.componentsRepl.components.get( EntityModelComponentReplicator );
		if ( modelRepl == null ) return;
		modelRepl.setFriendly();
	}

	public function setUnfriendly() {
		var modelRepl = controlledEntity.getValue()?.componentsRepl.components.get( EntityModelComponentReplicator );
		if ( modelRepl == null ) return;
		modelRepl.setUnfriendly();
	}

	public function sayMessage( text : String ) {
		var modelRepl = controlledEntity.getValue()?.componentsRepl.components.get( EntityModelComponentReplicator );
		if ( modelRepl == null ) return;
		modelRepl.sayText( text );
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
		if ( !controlledEntity?.getValue()?.entity.result?.disposed.isTriggered )
			controlledEntity.getValue()?.entity.result?.dispose();
		subscription.unsubscribe();
		BatchRenderer.inst?.dispose();

		disposed.resolve( true );
		inst = null;
	}

	override function update() {
		super.update();
		currentLocationSelf.val?.physics.getDebugDraw()?.update();
		currentLocationSelf.val?.physics?.drawDebug();

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
