package game.core.rules.overworld.entity.component;

import oimo.common.Vec3;
import util.Const;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.physics.RigidBodyAbstractFactory;
import game.physics.ShapeAbstractFactory;

class EntityRigidBodyComponent extends EntityPhysicalComponentBase {

	var torsoShape : IRigidBodyShape;

	var rigidBodyDesc : RigidBodyTorsoDescription;

	public function new( description : RigidBodyTorsoDescription ) {
		super( description );
		this.rigidBodyDesc = description;
	}

	function createRigidBody() {
		torsoShape = ShapeAbstractFactory.box(
			rigidBodyDesc.sizeX,
			rigidBodyDesc.sizeY,
			rigidBodyDesc.sizeZ
		);

		var rigidBodyLocal = RigidBodyAbstractFactory.create( torsoShape, DYNAMIC );

		torsoShape.setCollisionGroup( Const.G_PHYSICS );
		torsoShape.setCollisionMask( Const.G_PHYSICS );

		rigidBodyLocal.setRotationFactor( new Vec3() );
		rigidBodyLocal.setLinearDamping( new Vec3( 25, 25, 25 ) );
		rigidBodyLocal.setGravityScale( 40 );

		torsoShape.move( 0, 0, rigidBodyDesc.offsetZ - ( rigidBodyDesc.sizeX / 2 ) % 1 );

		return rigidBodyLocal;
	}
}
