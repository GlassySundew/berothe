package game.domain.overworld.location;

import game.physics.oimo.ContactCallbackWrapper;
import game.physics.ShapeAbstractFactory;
import game.physics.RigidBodyAbstractFactory;
import game.data.location.objects.LocationEntityTriggerVO;

class EntityTrigger {

	public var cb( default, null ) : ContactCallbackWrapper;

	final vo : LocationEntityTriggerVO;
	final location : Location;

	public function new( vo : LocationEntityTriggerVO, location : Location ) {
		this.vo = vo;
		this.location = location;
		init();
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
		torsoShape.setContactCallback( cb );

		var rigidBody = RigidBodyAbstractFactory.create(
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
