package game.net.entity;

import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import rx.disposables.Composite;
import game.domain.overworld.entity.OverworldEntity;
import net.NSMutableProperty;
import net.NetNode;

class EntityTransformReplicator extends NetNode {

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

	var entityRepl : EntityReplicator;

	public function new( ?parent ) {
		super( parent );
	}

	public function followEntityServer( entityRepl : EntityReplicator ) {
		this.entityRepl = entityRepl;

		// entity.transform.x.addOnValue( val -> trace( "got player x repl as " + val ) );

		setupServerSyncronization();
	}

	public function followEntityClient( entityRepl : EntityReplicator ) {
		this.entityRepl = entityRepl;

		setupClientSyncronization();
	}

	public function createModelToNetworkStream() {
		modelToNetworkStream?.unsubscribe();
		modelToNetworkStream = new Composite();

		var entity = entityRepl.entity.result;
		
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
		
		var entity = entityRepl.entity.result;

		networkToModelStream.add( x.subscribeProp( entity.transform.x ) );
		networkToModelStream.add( y.subscribeProp( entity.transform.y ) );
		networkToModelStream.add( z.subscribeProp( entity.transform.z ) );

		networkToModelStream.add( velX.subscribeProp( entity.transform.velX ) );
		networkToModelStream.add( velY.subscribeProp( entity.transform.velY ) );
		networkToModelStream.add( velZ.subscribeProp( entity.transform.velZ ) );

		networkToModelStream.add( rotationX.subscribeProp( entity.transform.rotationX ) );
		networkToModelStream.add( rotationY.subscribeProp( entity.transform.rotationY ) );
		networkToModelStream.add( rotationZ.subscribeProp( entity.transform.rotationZ ) );
	}

	function setupServerSyncronization() {
		createModelToNetworkStream();
		createNetworkToModelStream();
	}

	function setupClientSyncronization() {
		createNetworkToModelStream();
		// createModelToNetworkStream();
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		x.unregister( host, ctx );
		y.unregister( host, ctx );
		z.unregister( host, ctx );
		velX.unregister( host, ctx );
		velY.unregister( host, ctx );
		velZ.unregister( host, ctx );
		rotationX.unregister( host, ctx );
		rotationY.unregister( host, ctx );
		rotationZ.unregister( host, ctx );
	}
}
