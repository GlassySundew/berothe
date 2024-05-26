package en.comp.net;

import game.client.GameClient;
import util.Extensions.ArrayExtensions;
import h3d.Vector;
import oimo.common.Vec3;
import signals.Signal;
import dn.M;

using util.Extensions.ArrayExtensions;

class EntityDynamicsComponent extends EntityNetComponent {

	/** client **/
	/** server **/
	/** both client and server **/
	public var onMove( default, null ) : Signal = new Signal();
	public var onMoveInvalidate = false;

	public var entityPositionProvider : future.Future<IEntityPositionProvider> = new future.Future();

	var rigidBodyComponent : EntityRigidBodyComponent;

	public function new( entity : Entity, ?parent ) {
		super( entity, parent );
	}

	// public function cancelVelocities() {
	// 	dx = dy = 0;
	// }

	override function init() {
		super.init();

		entity.components.onAppear(
			EntityRigidBodyComponent,
			( key, component ) -> {
				rigidBodyComponent = component;
			}
		);

		entity.x.addOnValue(
			( oldVal ) -> if ( M.fabs( entity.x.val - oldVal ) > 0 )
				onMoveInvalidate = true
		);
		entity.y.addOnValue(
			( oldVal ) -> if ( M.fabs( entity.y.val - oldVal ) > 0 )
				onMoveInvalidate = true
		);
		entity.z.addOnValue(
			( oldVal ) -> if ( M.fabs( entity.z.val - oldVal ) > 0 ) {
				onMoveInvalidate = true;
			}
		);

		entityPositionProvider.then( ( _ ) -> {
			entity.onFrame.add( onFrame );
		} );
	}

	function onFrame() {
		if ( GameClient.inst == null ) return;

		var entityPos = entityPositionProvider.result;
		entityPos.update();

		if ( M.fabs( entityPos.velX ) <= 0.0005 * entity.tmod ) {
			entityPos.velX = 0;
		} else
			onMoveInvalidate = true;

		if ( M.fabs( entityPos.velY ) <= 0.0005 * entity.tmod ) {
			entityPos.velY = 0;
		} else
			onMoveInvalidate = true;

		if ( M.fabs( entityPos.velZ ) <= 0.0005 * entity.tmod ) {
			entityPos.velZ = 0;
		} else
			onMoveInvalidate = true;

		if ( onMoveInvalidate ) {
			onMove.dispatch();
			onMoveInvalidate = false;
		}
	}
}

class PixelPerfectMoving {

	var path : Array<Vector> = [];

	public function new() {}

	#if !debug inline #end
	public function checkIfPerfect( currentPosition : Vector, newPosition : Vector ) : Bool {
		// trace( path.length );
		if ( path.length > 1 && newPosition.equals( path.at( -1 ) ) ) return false;
		// trace( "passed last step check" );
		switch ( path.length ) {
			case 0:
				path.push( newPosition );
				return true;
			case 1:
				path.push( newPosition );
				return true;
			case 2:
				var result = true;
				// trace( path, "currentPos: " + currentPosition + " newPosition: " + newPosition + "; letter L : " + ( Math.abs( newPosition.x - path.at( -2 ).x ) == 1
				// 	&& Math.abs( newPosition.y - path.at( -2 ).y ) == 1 ) + "; dialgonal movement exc : " + ( path.at( -2 ).equals( currentPosition ) ) );
				// checking if we are making letter L
				if (
					Math.abs( newPosition.x - path.at( -2 ).x ) == 1
					&& Math.abs( newPosition.y - path.at( -2 ).y ) == 1
					&& !path.at( -2 ).equals( currentPosition ) ) result = false;

				// if ( path.at( -2 ).equals( currentPosition ) ) {
				// 	result = true;
				// }

				path.push( newPosition );
				path.shift();
				return result;
			default:
				throw "bad logic, path should not have more than 3 elements";
		}
	}
}
