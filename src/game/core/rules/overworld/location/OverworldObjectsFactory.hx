package game.core.rules.overworld.location;

import game.core.rules.overworld.entity.component.view.EntityViewComponent;
import util.Assert;
import game.core.rules.overworld.entity.component.block.StaticObjectRigidBodyComponent;
import game.core.rules.overworld.entity.EntityFactory;
import game.core.rules.overworld.entity.OverworldEntity;
import game.data.location.objects.LocationObject;

class OverworldObjectsFactory {

	public static var OBJECT_ID_INC = 0;

	final location : Location;

	public function new( location : Location ) {
		this.location = location;
	}

	public function createByDesc( objectDesc : LocationObject ) : OverworldEntity {
		var entity = new OverworldEntity( objectDesc.entityDesc, '${OBJECT_ID_INC++}' );

		EntityFactory.createAndAttachComponentsFromProperties( objectDesc.entityDesc, entity );

		entity.transform.setPosition( objectDesc.x, objectDesc.y, objectDesc.z );
		entity.transform.setRotation( objectDesc.rotationX, objectDesc.rotationY, objectDesc.rotationZ );

		var staticRBComponent = entity.components.get( StaticObjectRigidBodyComponent );
		Assert.notNull( staticRBComponent );
		staticRBComponent.provideConfiguration( {
			sizeX : objectDesc.sizeX,
			sizeY : objectDesc.sizeY,
			sizeZ : objectDesc.sizeZ
		} );

		var viewComponent = entity.components.get( EntityViewComponent );
		Assert.notNull( viewComponent );
		viewComponent.provideExtraViewConfig(
			Size(
				objectDesc.sizeX,
				objectDesc.sizeY,
				objectDesc.sizeZ
			)
		);

		return entity;
	}
}
