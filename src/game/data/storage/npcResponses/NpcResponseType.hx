package game.data.storage.npcResponses;

enum NpcResponseType {
	SAY( localeId : String );
	GIVE_QUEST( questId : String );
	TURN_AWAY_FROM_PLAYER;
	GENERATE_ITEM( itemDescId : String, amount : Int );
	UNFOCUS;
}

inline function fromCdb( entry : Data.NpcResponseActionType ) : NpcResponseType {
	return switch entry {
		case Say( text ): SAY( text.id.toString() );
		case GiveQuest( quest ): GIVE_QUEST( quest.id.toString() );
		case TurnAwayFromPlayer: TURN_AWAY_FROM_PLAYER;
		case GenerateItem( item, amount ): GENERATE_ITEM( item.id.toString(), amount );
		case Unfocus: UNFOCUS;
	}
}
