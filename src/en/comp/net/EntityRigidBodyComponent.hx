package en.comp.net;

import h3d.Vector;
import oimo.collision.geometry.BoxGeometry;
import oimo.collision.geometry.RayCastHit;
import oimo.common.Vec3;
import oimo.dynamics.World;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.RigidBodyType;
import oimo.dynamics.rigidbody.Shape;
import oimo.dynamics.rigidbody.ShapeConfig;
import util.Const;
import en.collide.EntityContactCallback;
import en.collide.RayCastCallback;
import en.comp.net.EntityDynamicsComponent.PixelPerfectMoving;

/**
	main body of an entity
**/
class EntityRigidBodyComponent extends EntityNetComponent implements IEntityPositionProvider {

	@:s var sizeX : Int;
	@:s var sizeY : Int;
	@:s var sizeZ : Int;

	@:s var offsetZ : Int;

	var halfSizeX : Float;
	var halfSizeY : Float;
	var halfSizeZ : Float;

	/** both server and client **/
	public var rigidBody( default, null ) : RigidBody;
	public var contactCb( default, null ) : EntityContactCallback;

	var world : World;
	var standRayCastCallback : RayCastCallback = new RayCastCallback();
	var torsoShape : Shape;

	public var velX( get, set ) : Float;
	inline function get_velX() : Float {
		return rigidBody._velX;
	}
	inline function set_velX( v : Float ) : Float {
		return rigidBody._velX = v;
	}

	public var velY( get, set ) : Float;
	inline function get_velY() : Float {
		return rigidBody._velY;
	}
	inline function set_velY( v : Float ) : Float {
		return rigidBody._velY = v;
	}

	public var velZ( get, set ) : Float;
	inline function get_velZ() : Float {
		return rigidBody._velZ;
	}
	inline function set_velZ( v : Float ) : Float {
		return rigidBody._velZ = v;
	}

	/** client **/
	var pixelPerfectMoving : PixelPerfectMoving = new PixelPerfectMoving();

	public function new(
		offsetZ : Int,
		sizeX : Int,
		sizeY : Int,
		sizeZ : Int,
		entity : Entity,
		?parent
	) {
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;

		this.offsetZ = offsetZ;

		super( entity, parent );
	}

	override function init() {
		super.init();

		halfSizeX = sizeX / 2;
		halfSizeY = sizeY / 2;
		halfSizeZ = sizeZ / 2;

		entity.onSpawned.handle(
			( level ) -> {
				createRigidBody();

				level.world.addRigidBody( rigidBody );
				world = level.world;

				rigidBody.setPosition( new Vec3( entity.x, entity.y, entity.z ) );
			}
		);

		entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamicsComponent ) -> {
				standRayCastCallback.onProcess.add( onRayCollide );

				dynamicsComponent.onMove.add(() -> {
					rigidBody.wakeUp();

					var start = torsoShape.getTransform().getPosition();
					var end = start.clone();
					end.z -= offsetZ;

					world.rayCast( start, end, standRayCastCallback );
				} );
				dynamicsComponent.onMoveInvalidate = true;
				dynamicsComponent.entityPositionProvider.resolve( this );
			}
		);
	}

	inline function onRayCollide( shape : Shape, rayCastHit : RayCastHit ) {
		if ( shape._collisionGroup & torsoShape._collisionMask == 0 ) return;

		rigidBody.translate( new Vec3( 0, 0, ( 1 - rayCastHit.fraction ) * offsetZ - halfSizeZ % 1 - 0.001 ) );

		if ( rigidBody._velX == 0 && rigidBody._velY == 0 ) {
			// rigidBody._transform._positionX = Std.int( rigidBody._transform._positionX );
			// rigidBody._transform._positionY = Std.int( rigidBody._transform._positionY );
			rigidBody.sleep();
		}
		velZ = 0;
	}

	function createRigidBody() {
		if ( rigidBody != null ) throw "bad logic, rigidBody is not suppposed to be created twice for one component";
		var torsoGeom = new BoxGeometry(
			new Vec3(
				halfSizeX,
				halfSizeY,
				halfSizeZ
			) );

		var shapec : ShapeConfig = new ShapeConfig();
		shapec.geometry = torsoGeom;
		torsoShape = new Shape( shapec );
		torsoShape.setCollisionGroup( Const.G_PHYSICS );
		torsoShape.setCollisionMask( Const.G_PHYSICS );
		var bodyc : RigidBodyConfig = new RigidBodyConfig();
		bodyc.type = RigidBodyType.DYNAMIC;
		rigidBody = new RigidBody( bodyc );
		rigidBody.addShape( torsoShape );
		rigidBody.setRotationFactor( new Vec3() );
		rigidBody.setLinearDamping( 25 );
		rigidBody.setGravityScale( 40 );

		// rigidBody.isPositionSnapped = true;

		torsoShape._localTransform._positionZ += offsetZ - halfSizeZ % 1;
	}

	public inline function getEntityPosition() : Vector {
		return new Vector(
			rigidBody._transform._positionX,
			rigidBody._transform._positionY,
			rigidBody._transform._positionZ
		);
	}

	public function update() {
		var newPosition = getEntityPosition();
		newPosition.x = newPosition.x;
		newPosition.y = newPosition.y;
		newPosition.z = newPosition.z;
		// newPosition.x = M.round( newPosition.x );
		// newPosition.y = M.round( newPosition.y );
		// newPosition.z = M.round( newPosition.z );

		var currentPosition = new Vector( entity.x, entity.y, entity.z );

		if ((
			Math.abs( newPosition.x - currentPosition.x ) > 0.001
			|| Math.abs( newPosition.y - currentPosition.y ) > 0.001
			|| Math.abs( newPosition.z - currentPosition.z ) > 0.001
		) && ( /**rigidBody.isPositionSnapped**/
			true || pixelPerfectMoving.checkIfPerfect(
				currentPosition,
				newPosition
			) ) ) {
				entity.setPos(
					newPosition.x,
					newPosition.y,
					newPosition.z
				);
		}
	}
}
