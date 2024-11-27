package game.domain.overworld.location;

import game.domain.overworld.location.physics.IRigidBody;
import game.physics.oimo.ContactCallbackWrapper;
import game.physics.ShapeAbstractFactory;
import game.physics.RigidBodyAbstractFactory;
import game.data.location.objects.LocationEntityTriggerVO;

class EntityTrigger {

	public var cb( default, null ) : ContactCallbackWrapper;

	public final vo : LocationEntityTriggerVO;
	final location : Location;
	var rigidBody : IRigidBody;

	public function new( vo : LocationEntityTriggerVO, location : Location ) {
		this.vo = vo;
		this.location = location;
		init();
	}

	public function dispose() {
		location.physics.removeRigidBody( rigidBody );
	}

	#if !debug inline #end
	function init() {
		cb = new ContactCallbackWrapper();

		var torsoShape = ShapeAbstractFactory.box(
			vo.sizeX,
			vo.sizeY,
			vo.sizeZ
		);
		torsoShape.setCollisionGroup( util.Const.G_PHYSICS );
		torsoShape.setCollisionMask( util.Const.G_PHYSICS );
		torsoShape.setContactCallbackWrapper( cb );

		rigidBody = RigidBodyAbstractFactory.create(
			torsoShape,
			TRIGGER
		);

		rigidBody.setPosition( {
			x : vo.x,
			y : vo.y,
			z : vo.z
		} );

		rigidBody.setRotation( vo.rotationX, vo.rotationY, vo.rotationZ );
		location.physics.addRigidBody( rigidBody );
	}
}
