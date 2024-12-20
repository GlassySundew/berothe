package game.client.en.comp.control;

#if client
import game.net.client.GameClient;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.EntityComponent;

class EntityCameraFollowComponent extends EntityClientComponent {

	public function recenter() {
		GameClient.inst.cameraProc.recenterCamera();

	}
	
	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		GameClient.inst.cameraProc.targetEntity.val = entity;
	}
}
#end
