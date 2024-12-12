package game.domain.overworld.entity.component.ai.behaviours;

import game.data.storage.DataStorage;
import game.data.storage.npcResponses.NpcResponseDescription;

class NpcQuestGiver extends EntityBehaviourBase {

	final responses : NpcResponseDescription;

	public function new( params ) {
		super( params );
		responses = DataStorage.inst.npcResponsesStorage.getById( params.npcResponsesId );
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		
	}
}
