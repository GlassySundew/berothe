package game.net.entity;

import rx.disposables.Composite;
import game.core.rules.overworld.entity.OverworldEntity;
import net.NSMutableProperty;
import net.NetNode;

class EntityTransformReplicator extends NetNode {

	@:s public final x : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final y : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final z : NSMutableProperty<Float> = new NSMutableProperty( 0. );

	public var modelToNetworkStream( default, null ) : Composite;
	public var networkToModelStream( default, null ) : Composite;

	// todo
	var rotationX : Float;
	var rotationY : Float;
	var rotationZ : Float;

	var entity : OverworldEntity;

	public function new( ?parent ) {
		super( parent );
	}

	public function followEntityServer( entity : OverworldEntity ) {
		this.entity = entity;

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
	}

	public function createNetworkToModelStream() {
		networkToModelStream?.unsubscribe();
		networkToModelStream = new Composite();

		networkToModelStream.add( x.subscribeProp( entity.transform.x ) );
		networkToModelStream.add( y.subscribeProp( entity.transform.y ) );
		networkToModelStream.add( z.subscribeProp( entity.transform.z ) );
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
