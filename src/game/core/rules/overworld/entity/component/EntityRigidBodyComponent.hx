package game.core.rules.overworld.entity.component;

import oimo.collision.geometry.BoxGeometry;
import oimo.common.Vec3;
import oimo.dynamics.rigidbody.RigidBody;
import oimo.dynamics.rigidbody.RigidBodyConfig;
import oimo.dynamics.rigidbody.RigidBodyType;
import oimo.dynamics.rigidbody.Shape;
import oimo.dynamics.rigidbody.ShapeConfig;
import util.Const;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;

class EntityRigidBodyComponent extends EntityComponent {

	var halfSizeX : Float;
	var halfSizeY : Float;
	var halfSizeZ : Float;

	var rigidBody : RigidBody;
	var torsoShape : Shape;

	var description : RigidBodyTorsoDescription;

	public function new( description : RigidBodyTorsoDescription ) {
		super( description );
		this.description = description;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		halfSizeX = description.sizeX / 2;
		halfSizeY = description.sizeY / 2;
		halfSizeZ = description.sizeZ / 2;
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

		torsoShape._localTransform._positionZ += description.offsetZ - halfSizeZ % 1;
	}
}
