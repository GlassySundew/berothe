package game.data.storage.npcResponses;

import haxe.exceptions.NotImplementedException;

enum NpcActivationTriggerType {
	TRIGGER_ON_APPROACH;
	TEXT_SAID( awaitSpeechId : String );
	QUEST_COMPLETED( questId : String );
	HAS_ITEM( itemId : String, amount : Int );
}

inline function fromCdb( entry : Data.NpcResponceChainAdvanceRequirementType ) : NpcActivationTriggerType {
	return switch entry {
		case TriggerOnApproach: TRIGGER_ON_APPROACH;
		case TextSaid( text ): TEXT_SAID( text.id.toString() );
		case QuestCompleted( quest ): QUEST_COMPLETED( quest.id.toString() );
		case HasItem( item, amount ): HAS_ITEM( item.id.toString(), amount );
	}
}
