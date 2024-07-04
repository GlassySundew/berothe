package game.core.rules.overworld.entity.component.block;

import oimo.common.Vec3;
import util.Assert;
import game.data.storage.entity.body.properties.StaticObjectRigidBodyDescription;
import game.core.rules.overworld.location.physics.IRigidBody;
import game.physics.ShapeAbstractFactory;
import game.physics.RigidBodyAbstractFactory;
import util.Const;

typedef StaticObjectConfiguration = {
	var sizeX : Float;
	var sizeY : Float;
	var sizeZ : Float;
}

class StaticObjectRigidBodyComponent extends EntityPhysicalComponentBase {

	var rigidBodyDesc : StaticObjectRigidBodyDescription;
	var config : StaticObjectConfiguration;

	public function new( desc : StaticObjectRigidBodyDescription ) {
		super( desc );
		this.rigidBodyDesc = desc;
	}

	public function provideConfiguration( config : StaticObjectConfiguration ) {
		this.config = config;
	}

	function createRigidBody() : IRigidBody {
		Assert.notNull( config );

		var torsoShape = ShapeAbstractFactory.box(
			config.sizeX,
			config.sizeY,
			config.sizeZ
		);

		var rigidBodyLocal = RigidBodyAbstractFactory.create( torsoShape, STATIC );

		torsoShape.setCollisionGroup( Const.G_PHYSICS );
		torsoShape.setCollisionMask( Const.G_PHYSICS );

		rigidBodyLocal.setGravityScale( 40 );

		return rigidBodyLocal;
	}
}
