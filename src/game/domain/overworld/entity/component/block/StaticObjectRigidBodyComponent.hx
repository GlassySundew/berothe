package game.domain.overworld.entity.component.block;

import rx.disposables.Composite;
import game.domain.overworld.location.OverworldLocationMain;
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

	override function onAttachedToLocation( oldLoc : OverworldLocationMain, location : OverworldLocationMain ) {
		super.onAttachedToLocation( oldLoc, location );
		if ( location == null ) return;
		subscription.add( entity.transform.x.subscribeProp( rigidBody.x, true ) );
		subscription.add( entity.transform.y.subscribeProp( rigidBody.y, true ) );
		subscription.add( entity.transform.z.subscribeProp( rigidBody.z, true ) );
		subscription.add( entity.transform.velX.subscribeProp( rigidBody.velX, true ) );
		subscription.add( entity.transform.velY.subscribeProp( rigidBody.velY, true ) );
		subscription.add( entity.transform.velZ.subscribeProp( rigidBody.velZ, true ) );
		subscription.add( entity.transform.rotationX.subscribeProp( rigidBody.rotationX, true ) );
		subscription.add( entity.transform.rotationY.subscribeProp( rigidBody.rotationY, true ) );
		subscription.add( entity.transform.rotationZ.subscribeProp( rigidBody.rotationZ, true ) );
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
