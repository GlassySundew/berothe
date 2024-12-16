package game.net.entity;

import game.net.server.GameServer;
import rx.disposables.ISubscription;
import h3d.Vector;
import haxe.Timer;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import rx.disposables.Composite;
import game.domain.overworld.entity.OverworldEntity;
import net.NSMutableProperty;
import net.NetNode;

class EntityTransformReplicator extends NetNode {

	static final maxInterpolationTime = 200;

	@:s public final x : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final y : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final z : NSMutableProperty<Float> = new NSMutableProperty( 0. );

	@:s public final velX : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final velY : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final velZ : NSMutableProperty<Float> = new NSMutableProperty( 0. );

	@:s public final rotationX : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final rotationY : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final rotationZ : NSMutableProperty<Float> = new NSMutableProperty( 0. );

	public var modelToNetworkStream( default, null ) : Composite;
	public var networkToModelStream( default, null ) : Composite;

	public var ignoreSync = false;

	var entity : OverworldEntity;

	// interpolation
	var lastUpdateTS : Float;
	var lastSyncX : Float;
	var lastSyncY : Float;
	var lastSyncZ : Float;
	var interpolationSub : Composite;

	public function new( ?parent ) {
		super( parent );
	}

	public function followEntityServer( entity : OverworldEntity ) {
		followEntity( entity );

		setupServerSyncronization();
	}

	public function followEntityClient( entity : OverworldEntity ) {
		followEntity( entity );

		setupClientSyncronization();
	}

	public function createModelToNetworkStream() {
		modelToNetworkStream?.unsubscribe();
		modelToNetworkStream = new Composite();

		modelToNetworkStream.add( entity.transform.x.subscribeProp( x ) );
		modelToNetworkStream.add( entity.transform.y.subscribeProp( y ) );
		modelToNetworkStream.add( entity.transform.z.subscribeProp( z ) );

		modelToNetworkStream.add( entity.transform.velX.subscribeProp( velX ) );
		modelToNetworkStream.add( entity.transform.velY.subscribeProp( velY ) );
		modelToNetworkStream.add( entity.transform.velZ.subscribeProp( velZ ) );

		modelToNetworkStream.add( entity.transform.rotationX.subscribeProp( rotationX ) );
		modelToNetworkStream.add( entity.transform.rotationY.subscribeProp( rotationY ) );
		modelToNetworkStream.add( entity.transform.rotationZ.subscribeProp( rotationZ ) );
	}

	public function createNetworkToModelStream() {
		networkToModelStream?.unsubscribe();
		networkToModelStream = new Composite();

		#if server
		networkToModelStream.add( x.addOnValueImmediately(
			( _, newV ) -> @:privateAccess { //
				if ( !ignoreSync ) entity.transform.x.val = newV;
				else x.maskVal = entity.transform.x.val;
			} ) );
		networkToModelStream.add( y.addOnValueImmediately(
			( _, newV ) -> @:privateAccess { //
				if ( !ignoreSync ) entity.transform.y.val = newV;
				else y.maskVal = entity.transform.y.val;
			} ) );
		networkToModelStream.add( z.addOnValueImmediately(
			( _, newV ) -> @:privateAccess { //
				if ( !ignoreSync ) entity.transform.z.val = newV
				else {
					z.maskVal = entity.transform.z.val;
				}
			} ) );
		#else
		networkToModelStream.add( x.subscribeProp( entity.transform.x ) );
		networkToModelStream.add( y.subscribeProp( entity.transform.y ) );
		networkToModelStream.add( z.subscribeProp( entity.transform.z ) );
		#end

		networkToModelStream.add( velX.subscribeProp( entity.transform.velX ) );
		networkToModelStream.add( velY.subscribeProp( entity.transform.velY ) );
		networkToModelStream.add( velZ.subscribeProp( entity.transform.velZ ) );

		networkToModelStream.add( rotationX.subscribeProp( entity.transform.rotationX ) );
		networkToModelStream.add( rotationY.subscribeProp( entity.transform.rotationY ) );
		networkToModelStream.add( rotationZ.subscribeProp( entity.transform.rotationZ ) );
	}

	function followEntity( entity : OverworldEntity ) {
		this.entity = entity;
	}

	public function claimOwnage() {}

	function setupServerSyncronization() {
		createModelToNetworkStream();
		createNetworkToModelStream();
	}

	function setupClientSyncronization() {
		createNetworkToModelStream();
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		x.unregister( host, ctx );
		y.unregister( host, ctx );
		z.unregister( host, ctx );
		velX.unregister( host, ctx );
		velY.unregister( host, ctx );
		velZ.unregister( host, ctx );
		rotationX.unregister( host, ctx );
		rotationY.unregister( host, ctx );
		rotationZ.unregister( host, ctx );
		super.unregister( host, ctx );
	}
}
