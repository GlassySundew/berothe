package en.comp.net;

import oimo.dynamics.rigidbody.RigidBodyType;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import util.Const;
import oimo.dynamics.rigidbody.Shape;
import oimo.dynamics.rigidbody.ShapeConfig;
import oimo.common.Vec3;
import oimo.collision.geometry.BoxGeometry;
import oimo.dynamics.rigidbody.RigidBody;
import h3d.Vector;

class EntityHitboxComponent extends EntityNetComponent {

	@:s var sizeX : Int;
	@:s var sizeY : Int;
	@:s var sizeZ : Int;

	@:s var offsetZ : Int;

	var halfSizeX : Float;
	var halfSizeY : Float;
	var halfSizeZ : Float;

	var rigidBody : RigidBody;
	var hitboxShape : Shape;

	public function new(
		offsetZ : Int,
		sizeX : Int,
		sizeY : Int,
		sizeZ : Int,
		entity : Entity,
		?parent
	) {
		this.offsetZ = offsetZ;

		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
	
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

				rigidBody.setPosition( new Vec3( entity.x, entity.y, entity.z ) );
			}
		);

		entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamicsComponent ) -> {

				dynamicsComponent.onMove.add(() -> {
					rigidBody.setPosition( new Vec3( entity.x, entity.y, entity.z ) );
				} );
			}
		);
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
		hitboxShape = new Shape( shapec );
		hitboxShape.setCollisionGroup( Const.G_HITBOX );
		hitboxShape.setCollisionMask( Const.G_ENTITY_HITBOX );
		var bodyc : RigidBodyConfig = new RigidBodyConfig();
		bodyc.type = RigidBodyType.KINEMATIC;
		rigidBody = new RigidBody( bodyc );
		rigidBody.addShape( hitboxShape );
		rigidBody.setRotationFactor( new Vec3() );

		hitboxShape._localTransform._positionZ += offsetZ - halfSizeZ % 1;
	}
}
