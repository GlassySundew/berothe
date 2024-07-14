package game.net.entity;

import rx.disposables.Composite;
import game.core.rules.overworld.entity.OverworldEntity;
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

	var entity : OverworldEntity;

	public function new( ?parent ) {
		super( parent );
	}

	public function followEntityServer( entity : OverworldEntity ) {
		this.entity = entity;

		// entity.transform.x.addOnValue( val -> trace( "got player x repl as " + val ) );

		setupServerSyncronization();
	}

	public function followEntityClient( entity : OverworldEntity ) {
		this.entity = entity;

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
		createModelToNetworkStream();
	}
}
