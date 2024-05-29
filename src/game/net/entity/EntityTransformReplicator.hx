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

	public function followEntity( entity : OverworldEntity ) {
		this.entity = entity;

		entity.transform.x.subscribeProp( x );
		entity.transform.y.subscribeProp( y );
		entity.transform.z.subscribeProp( z );
	}
}
