package game.data.storage.entity.body.properties;

import game.data.storage.entity.component.EntityComponentDescription;

class AIProperties {

	public final triggerId : Null<String>;
	public final agroRange : Null<Float>;
	public final npcResponsesId : Null<String>;
	public final npcResponseEntryChainId : Null<String>;

	public inline function new( entry : Data.EntityPropertySetup_properties_behaviour_params ) {
		triggerId = entry.triggerId;
		agroRange = entry.agroRange;
		npcResponsesId = entry.npcResponsesId.toString();
		npcResponseEntryChainId = entry.npcResponseEntryChainId.toString();
	}
}

inline function getTypeFromCdb( cdbEntry : Data.NpcBehaviour ) : EntityBehaviourType {
	return
		switch cdbEntry.id {
			case flowerPollinator: FLOWER_POLLINATOR;
			case sleepyPointGuard: SLEEPY_POINT_GUARD;
			case randomRoaming: RANDOM_ROAMING;
			case npcQuestGiver: NPC_QUEST_GIVER;
		}
}

enum abstract EntityBehaviourType( String ) to String {

	var FLOWER_POLLINATOR;
	var SLEEPY_POINT_GUARD;
	var RANDOM_ROAMING;
	var NPC_QUEST_GIVER;
}

class EntityAIDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb(
		entry : Data.EntityPropertySetup_properties_behaviour
	) : Null<EntityAIDescription> {

		if ( entry == null ) return null;
		return new EntityAIDescription(
			getTypeFromCdb( entry.type ),
			entry.params != null ? new AIProperties( entry.params ) : null
		);
	}

	public final type : EntityBehaviourType;
	public final params : AIProperties;

	public function new(
		id : EntityBehaviourType,
		params : AIProperties
	) {
		super( id );
		type = id;
		this.params = params;

		// #if !debug
		isReplicable = false;
		// #end
	}
}
