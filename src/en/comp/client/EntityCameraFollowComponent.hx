package en.comp.client;

import game.client.GameClient;

class EntityCameraFollowComponent extends EntityComponent {

	public function new( entity ) {
		super( entity );

		// entity.clientComponents.onAppear(
		// 	EntityViewComponent,
		// 	( key, component ) -> {
		// 		GameClient.inst.cameraProc.targetEntity.val = entity;
		// 	}
		// );
	}
}
