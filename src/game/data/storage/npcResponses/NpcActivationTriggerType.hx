package game.data.storage.npcResponses;

enum NpcActivationTriggerType {
	TRIGGER_ON_APPOACH;
	TEXT_SAID( awaitSpeechId : String );
	QUEST_COMPLETED( questId : String );
}

inline function fromCdb( entry : Data.NpcResponceChainAdvanceRequirementType ) : NpcActivationTriggerType {
	return switch entry {
		case TriggerOnApproach: TRIGGER_ON_APPOACH;
		case TextSaid( text ): TEXT_SAID( text.id.toString() );
		case QuestCompleted( quest ): QUEST_COMPLETED( quest.id.toString() );
	}
}
