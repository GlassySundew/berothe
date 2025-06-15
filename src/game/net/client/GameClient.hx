package game.net.client;

import net.ClientCommandType;
import rx.ObservableFactory;
import rx.Observable;
import net.ClientController.InfoMessageType;
import h3d.scene.Light;
import future.Future;
import graphics.BatchRenderer;
import hrt.prefab.RenderProps;
import hxd.Res;
import pass.PbrSetup.PbrRenderer;
import rx.disposables.Composite;
import util.threeD.ModelCache;
import game.net.entity.component.EntityModelComponentReplicator;
#if client
import core.IProperty;
import core.MutableProperty;
import dn.Process;
import dn.heaps.input.ControllerAccess;
import h3d.scene.CameraController;
import h3d.scene.Object;
import hxbit.NetworkSerializable;
import net.Client;
import net.NetNode;
import signals.Signal;
import ui.PauseMenu;
import util.Const;
import util.Settings;
import util.threeD.CameraProcess;
import game.client.ControllerAction;
import game.data.storage.DataStorage;
import game.debug.HeapsOimophysicsDebugDraw;
import game.debug.ImGuiGameClientDebug;
import game.domain.depr.overworld.GameCoreDepr;
import game.domain.overworld.location.OverworldLocationMain;
import game.net.entity.EntityReplicator;

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

	final currentLocationSelf : MutableProperty<OverworldLocationMain> = new MutableProperty();
	public var currentLocation( get, never ) : IProperty<OverworldLocationMain>;
	inline function get_currentLocation() : IProperty<OverworldLocationMain> {
		return currentLocationSelf;
	}

	public final onUpdate : Signal = new Signal();
	public final core : GameCoreDepr = new GameCoreDepr();
	public final controlledEntity : MutableProperty<EntityReplicator> = new MutableProperty();
	public final cameraProc : CameraProcess;
	public final modelCache : ModelCache = new ModelCache();
	public final disposed = new Future();

	public final infoMessageStream = new Future<Observable<InfoMessageType>>();

	final subscription = Composite.create();
	final onClientInfoMessage = new Signal<InfoMessageType>();

	var imguiPanel : ImGuiGameClientDebug;
	var locationLights : hrt.prefab.Prefab;
	var escapeCa : ControllerAccess<EscapeAction>;
	var cam : CameraController;

	public function new() {
		super( ClientMain.inst );

		#if debug
		// new AxesHelper( Boot.inst.s3d );
		// new GridHelper( Boot.inst.s3d );
		#end

		inst = this;
		escapeCa = ClientMain.inst.escapeController.createAccess();

		createRootInLayers( ClientMain.inst.root, Const.DP_BG );

		cameraProc = new CameraProcess( ClientBoot.inst.s3d.camera, this );
		cameraProc.doRound = false;

		subscription.add( Client.inst.onUnregister.add( onUnregister ) );

		var renderPropsRes = Res.levels.renderprops.load().make();
		renderPropsRes.findAll( RenderProps )[0]?.applyProps( ClientBoot.inst.s3d.renderer );

		currentLocationSelf.addOnValue( ( oldLoc, newLoc ) -> {
			locationLights?.findFirstLocal3d().remove();
			locationLights = null;

			if ( oldLoc != null ) {
				// if ( !controlledEntity.getValue().entity.result?.disposed.isTriggered )
				// 	oldLoc.removeEntity( controlledEntity.getValue().entity.result );
				// #if debug
				// oldLoc.physics.getDebugDraw()?.remove();
				// #end
				// oldLoc.dispose();
			}

			if ( newLoc == null ) return;

			// Std.downcast( ClientBoot.inst.s3d.renderer, PbrRenderer ).env.power = newLoc.locationDesc.isOpenAir ? 0.7 : 0.4;

			// if ( newLoc.locationDesc.isOpenAir ) {
			// 	locationLights?.findFirstLocal3d().remove();
			// 	locationLights = Res.levels.light.load().make();
			// 	ClientBoot.inst.s3d.addChild( locationLights.findFirstLocal3d() );
			// }
		} );

		#if debug
		imguiPanel = new game.debug.ImGuiGameClientDebug( GameClient.inst );
		#end

		ClientMain.inst.cliCon.onAppear( cliCon -> {
			infoMessageStream.resolve(
				ObservableFactory.fromSignal( cliCon.onInfoMessage )
					.append( ObservableFactory.fromSignal( onClientInfoMessage ) )
			);
		} );
	}

	public function consoleSay( text : String ) {
		ClientMain.inst.console.log( text );
	}

	public function onLocationProvided( locationDescId : String ) {
		controlledEntity.onAppear( ( playerRepl ) -> {
			new graphics.BatchRenderer( ClientBoot.inst.s3d );
			// currentLocationSelf.val = core.getOrCreateLocationByDesc(
			// 	DataStorage.inst.locationStorage.getById(
			// 		locationDescId
			// 	),
			// 	playerRepl.entity.result
			// );

			#if debug debugDraw(); #end
		} );
	}

	public function setFriendly() {
		var modelRepl = getControlledModel();
		if ( modelRepl == null ) return;
		modelRepl.setFriendly();
	}

	public function setUnfriendly() {
		var modelRepl = getControlledModel();
		if ( modelRepl == null ) return;
		modelRepl.setUnfriendly();
	}

	public function sayMessage( text : String ) {
		var modelRepl = getControlledModel();
		if ( modelRepl == null ) return;
		modelRepl.sayText( text );
	}

	public function emitInfoMessage( type : InfoMessageType ) {
		onClientInfoMessage.dispatch( type );
	}

	public function sendCommand( commandType : ClientCommandType ) {
		switch commandType {
			case CHAMPION:
				var model = getControlledModel();
				if (
					model.displayName.getValue() == ""
					|| model.displayName.getValue() == null
				) {}
		}

		// Main.inst.cliCon.val.sendTransaction
	}

	inline function getControlledModel() : Null<EntityModelComponentReplicator> {
		return controlledEntity.getValue()?.componentsRepl.components.get( EntityModelComponentReplicator );
	}

	#if( client && debug )
	function debugDraw() {
		var physicsDebugView = new HeapsOimophysicsDebugDraw( ClientBoot.inst.s3d );
		// currentLocationSelf.val.physics.setDebugDraw( physicsDebugView );
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

		escapeCa.dispose();

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
		// currentLocationSelf.val?.physics.getDebugDraw()?.update();
		// currentLocationSelf.val?.physics?.drawDebug();

		if ( escapeCa.isPressed( ESCAPE ) ) {
			new PauseMenu( this, ClientMain.inst.root, ClientMain.inst );
		}

		// currentLocationSelf.val?.update( hxd.Timer.dt, tmod );
		onUpdate.dispatch();

		BatchRenderer.inst?.emitBatches();

		var frustum = ClientBoot.inst.s3d.camera.frustum;
		function getRec( obj : h3d.scene.Object ) {
			if ( !Std.isOfType( obj, Light ) ) {
				var bounds = obj.getBounds();
				obj.culled = !frustum.hasBounds( bounds );
			}
			for ( o in obj )
				getRec( o );
		}
		getRec( ClientBoot.inst.s3d );
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
