package game.core.rules.overworld.entity.component;

import oimo.common.Vec3;
import util.Const;
import game.core.rules.overworld.location.Location;
import game.core.rules.overworld.location.physics.IPhysicsEngine;
import game.core.rules.overworld.location.physics.IRigidBody;
import game.core.rules.overworld.location.physics.IRigidBodyShape;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.physics.RigidBodyAbstractFactory;
import game.physics.ShapeAbstractFactory;

class EntityRigidBodyComponent extends EntityComponent {

	var physics : IPhysicsEngine;
	var rigidBody : IRigidBody;
	var torsoShape : IRigidBodyShape;

	var rigidBodyDesc : RigidBodyTorsoDescription;

	public function new( description : RigidBodyTorsoDescription ) {
		super( description );
		this.rigidBodyDesc = description;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		createRigidBody();

		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {
		physics = location.physics;
		physics.addRigidBody( rigidBody );
	}

	function createRigidBody() {
		if ( rigidBody != null )
			throw "bad logic, rigidBody is not suppposed to be created twice for one component";

		torsoShape = ShapeAbstractFactory.box(
			rigidBodyDesc.sizeX,
			rigidBodyDesc.sizeY,
			rigidBodyDesc.sizeZ
		);

		rigidBody = RigidBodyAbstractFactory.create( torsoShape, DYNAMIC );

		torsoShape.setCollisionGroup( Const.G_PHYSICS );
		torsoShape.setCollisionMask( Const.G_PHYSICS );

		rigidBody.setRotationFactor( new Vec3() );
		rigidBody.setLinearDamping( new Vec3( 25, 25, 25 ) );
		rigidBody.setGravityScale( 40 );

		torsoShape.move( 0, 0, rigidBodyDesc.offsetZ - ( rigidBodyDesc.sizeX / 2 ) % 1 );
	}
}
