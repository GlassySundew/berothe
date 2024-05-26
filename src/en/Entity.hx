package en;

import dn.Tweenie;
import game.Level;
import game.client.GameClient;
import game.server.GameServer;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable;
import net.NSMutableProperty;
import net.NetNode;
import signals.Signal;
import tink.CoreApi.Future;
import tink.CoreApi.FutureTrigger;
import util.Const;
import en.comp.EntityComponents;
import en.comp.EntityNetComponents;
// import en.comp.client.EntityViewComponent;
import en.model.EntityModel;

using util.TmxUtils;
using en.util.EntityUtil;

class Entity extends NetNode {

	public static var ALL : Array<Entity> = [];
	public static var ServerALL : Array<Entity> = [];
	public static var GC : Array<Entity> = [];

	@:s public var model : EntityModel = new EntityModel();

	/**
		contains components that are replicated over network
	**/
	@:s public var components : EntityNetComponents;

	@:s public var x : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public var y : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public var z : NSMutableProperty<Float> = new NSMutableProperty( 0. );

	/** client **/
	public var isDestroyed( default, null ) = false;

	public var cd : dn.Cooldown;
	public var tw : Tweenie;

	public var tmod( get, never ) : Float;
	inline function get_tmod() {
		return
			if ( GameClient.inst != null )
				GameClient.inst.tmod
			else
				GameServer.inst.tmod;
	}

	public var clientComponents : EntityComponents = new EntityComponents();

	/** server **/
	public var serverComponents : EntityComponents = new EntityComponents();

	/**
		both client and server
	**/
	public var onSpawned( default, null ) : FutureTrigger<Level> = Future.trigger();
	public var onFrame : Signal = new Signal();

	/** server-side **/
	public function new( ?parent ) {
		ServerALL.push( this );
		components = new EntityNetComponents( this, parent );
		super( parent );
	}

	public override function init() {
		super.init();

		cd = new dn.Cooldown( Const.FPS );
		tw = new Tweenie( Const.FPS );
	}

	/**
		called only on client-side when
		replicating entity over network to client side
	**/
	public override function alive() {
		super.alive();
		ALL.push( this );

		createView();
		onSpawned.trigger( model.level );
	}

	function createView() {
		// var view = new EntityViewComponent( Data.EntityBodyKind.get( model.cdb.val ).view, this );
		// clientComponents.add( view );
	}

	@:rpc
	public function destroy() {
		if ( !isDestroyed ) {
			isDestroyed = true;
			GC.push( this );
		}
	}

	@:allow( game.client.GameClient, game.server.GameServer )
	function dispose() {
		isDestroyed = true;
		ALL.remove( this );

		cd.dispose();
		tw.destroy();
	}

	@:rpc
	public function setPosRpc( x : Float, y : Float, z : Float ) {
		setPos( x, y, z );
	}

	public inline function setPos( x : Float, y : Float, z : Float ) {
		this.x.val = x;
		this.y.val = y;
		this.z.val = z;
	}

	// public function kill( by : Null<Entity> ) {
	// 	Save.inst.removeEntityById( model.sqlId );
	// 	destroy();
	// }
	// public function unreg( host : NetworkHost, ctx : NetworkSerializer, ?finalize ) @:privateAccess {
	// 	host.unregister( model.footX, ctx, finalize );
	// 	host.unregister( model.footY, ctx, finalize );
	// }

	public function headlessPreUpdate() {}

	public function headlessUpdate() {
		onFrame.dispatch();
	}

	public function headlessPostUpdate() {}

	public function headlessFrameEnd() {}

	public function preUpdate() {
		cd.update( tmod );
		tw.update( tmod );
	}

	public function update() {
		onFrame.dispatch();
	}

	public function postUpdate() {}

	public function frameEnd() {}
}
