package game.domain.overworld.location;

import game.net.client.GameClient;
import game.domain.overworld.entity.component.EntityInteractableComponent;
import hrt.prefab.Model;
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

	public function createByDesc(
		objectDesc : LocationEntityVO,
		isAuth = true
	) : OverworldEntity {
		// the only exclusion for static objects that are not
		// replicated over network and created on client side from location data file
		var entity = new OverworldEntity( objectDesc.entityDesc, '${OBJECT_ID_INC++}' );

		EntityFactory.createAndAttachComponentsFromProperties( objectDesc.entityDesc, entity );

		entity.transform.setPosition( objectDesc.x, objectDesc.y, objectDesc.z );
		entity.transform.setRotation(
			objectDesc.rotationX,
			objectDesc.rotationY,
			objectDesc.rotationZ
		);

		provideSizeToStatic( entity, objectDesc );

		if ( !isAuth ) {
			EntityFactory.createAndAttachClientComponentsFromProperties(
				objectDesc.entityDesc,
				entity
			);

			var viewComponent = entity.components.get( EntityViewComponent );
			Assert.notNull( viewComponent );
			if ( objectDesc.prefab is Model ) {
				viewComponent.provideExtraViewConfig(
					File( Std.downcast( objectDesc.prefab, Model ).source )
				);
			}
			viewComponent.provideExtraViewConfig(
				Size(
					objectDesc.sizeX,
					objectDesc.sizeY,
					objectDesc.sizeZ
				)
			);
		}

		if ( objectDesc.isBatched ) {
			entity.components.onAppear(
				EntityViewComponent,
				( _, viewComp ) -> {
					viewComp.isBatched.val = true;
				}
			);
		}

		#if client
		entity.components.onAppear(
			EntityInteractableComponent,
			( cl, comp ) -> {
				comp.interactive.then(
					( int ) -> int.onClick.add(
						( e ) -> comp.useBy( GameClient.inst.controlledEntity.val.entity.result )
					)
				);
			}
		);
		#end

		return entity;
	}

	inline function provideSizeToStatic(
		entity : OverworldEntity,
		objectDesc : LocationEntityVO
	) {
		var staticRBComponent = entity.components.get( StaticObjectRigidBodyComponent );
		if ( staticRBComponent != null )
			staticRBComponent.provideConfiguration( {
				sizeX : objectDesc.sizeX,
				sizeY : objectDesc.sizeY,
				sizeZ : objectDesc.sizeZ
			} );
	}
}
