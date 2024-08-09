package game.client.en.comp.control;

#if client
import game.net.client.GameClient;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.EntityComponent;

class EntityCameraFollowComponent extends EntityClientComponent {

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		GameClient.inst.cameraProc.targetEntity.val = entity;
	}
}
#end
