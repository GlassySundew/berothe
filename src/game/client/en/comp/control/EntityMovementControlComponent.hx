package game.client.en.comp.control;

#if client
import core.IProperty;
import core.MutableProperty;
import dn.M;
import dn.heaps.input.ControllerAccess;
import util.Const;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.component.EntityDynamicsComponent;
import game.net.entity.EntityReplicator;
import game.net.entity.component.EntityDynamicsComponentReplicator;

class EntityMovementControlComponent extends EntityComponent {

	public var inputDirX( default, null ) : Float = 0;
	public var inputDirY( default, null ) : Float = 0;

	final entityReplicator : EntityReplicator;
	final ca : ControllerAccess<ControllerAction>;

	var dynamicsComponent : EntityDynamicsComponent;

	// TODO temp
	var speed = 8;

	final isMovementAppliedSelf : MutableProperty<Bool> = new MutableProperty( false );
	public var isMovementApplied( get, never ) : IProperty<Bool>;
	inline function get_isMovementApplied() : IProperty<Bool> {
		return isMovementAppliedSelf;
	}

	public function new( entityReplicator : EntityReplicator, ca : ControllerAccess<ControllerAction> ) {
		super( null );

		this.ca = ca;
		this.entityReplicator = entityReplicator;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamicsComponent ) -> {
				this.dynamicsComponent = dynamicsComponent;
				entity.onFrame.add( update );
			}
		);

		var dynamicsReplicator = entityReplicator.componentsRepl.components.get( EntityDynamicsComponentReplicator );
		dynamicsReplicator.followedComponent.then( ( component ) -> {
			var dynamics : EntityDynamicsComponent = Std.downcast( component, EntityDynamicsComponent );
			isMovementAppliedSelf.subscribeProp( dynamics.isMovementApplied );
		} );
	}

	function update( dt : Float, tmod : Float ) {
		var lx = ca.getAnalogValue2( MoveLeft, MoveRight );
		var ly = ca.getAnalogValue2( MoveDown, MoveUp );

		if ( Math.abs( lx ) == 1 && Math.abs( ly ) == 1 ) { // wasd cornering
			lx *= Math.cos( Const.FOURTY_FIVE_DEGREE_RAD );
			ly *= Math.sin( Const.FOURTY_FIVE_DEGREE_RAD );
		}

		var leftDist = M.dist( 0, 0, lx, ly );
		isMovementAppliedSelf.val = leftDist >= 0.3;
		var leftAng = Math.atan2( ly, lx );

		if ( isMovementAppliedSelf.val ) {
			var s = leftDist * speed * Main.inst.tmod;
			inputDirX = Math.cos( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;
			inputDirY = -Math.sin( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;
			entity.transform.velX.val += inputDirX;
			entity.transform.velY.val += inputDirY;
		}

		// for ( i in haxe.CallStack.callStack() )
		// 	for ( i in haxe.CallStack.callStack() )
		// 		// for ( i in haxe.CallStack.callStack() )
		// 		for ( i in haxe.CallStack.callStack() )
		// 			Std.parseFloat( ".0123" );
	}
}
#end
