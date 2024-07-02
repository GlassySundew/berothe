package game.net.entity;

import game.core.rules.overworld.entity.OverworldEntity;
import net.NSMutableProperty;
import net.NetNode;

class EntityTransformReplicator extends NetNode {

	@:s public final x : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final y : NSMutableProperty<Float> = new NSMutableProperty( 0. );
	@:s public final z : NSMutableProperty<Float> = new NSMutableProperty( 0. );

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

		x.addOnValue( ( val ) -> trace( "got x change as " + val ) );
	}

	function setupServerSyncronization() {
		entity.transform.x.subscribeProp( x );
		entity.transform.y.subscribeProp( y );
		entity.transform.z.subscribeProp( z );
		x.subscribeProp( entity.transform.x );
		y.subscribeProp( entity.transform.y );
		z.subscribeProp( entity.transform.z );
	}

	function setupClientSyncronization() {
		x.subscribeProp( entity.transform.x );
		y.subscribeProp( entity.transform.y );
		z.subscribeProp( entity.transform.z );
		entity.transform.x.subscribeProp( x );
		entity.transform.y.subscribeProp( y );
		entity.transform.z.subscribeProp( z );
	}
}
