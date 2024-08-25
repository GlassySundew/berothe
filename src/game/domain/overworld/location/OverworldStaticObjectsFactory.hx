package game.domain.overworld.location;

import game.client.en.comp.view.EntityViewComponent;
import util.Assert;
import game.domain.overworld.entity.component.block.StaticObjectRigidBodyComponent;
import game.domain.overworld.entity.EntityFactory;
import game.domain.overworld.entity.OverworldEntity;
import game.data.location.objects.LocationEntityVO;

class OverworldStaticObjectsFactory {

	public static var OBJECT_ID_INC = 0;

	final location : Location;

	public function new( location : Location ) {
		this.location = location;
	}

	public function createByDesc( objectDesc : LocationEntityVO ) : OverworldEntity {
		// the only exclusion for static objects that are not 
		// replicated over network and created on client side from location data file
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
