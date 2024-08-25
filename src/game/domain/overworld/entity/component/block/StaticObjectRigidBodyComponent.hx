package game.domain.overworld.entity.component.block;

import game.domain.overworld.entity.component.EntityRigidBodyComponentBase;
import util.Assert;
import util.Const;
import game.domain.overworld.entity.component.EntityPhysicsComponentBase;
import game.domain.overworld.location.physics.IRigidBody;
import game.data.storage.entity.body.properties.StaticObjectRigidBodyDescription;
import game.physics.RigidBodyAbstractFactory;
import game.physics.ShapeAbstractFactory;

typedef StaticObjectConfiguration = {
	var sizeX : Float;
	var sizeY : Float;
	var sizeZ : Float;
}

class StaticObjectRigidBodyComponent extends EntityRigidBodyComponentBase {

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

		return rigidBodyLocal;
	}
}
