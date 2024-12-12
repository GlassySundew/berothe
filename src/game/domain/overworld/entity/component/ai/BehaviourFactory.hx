package game.domain.overworld.entity.component.ai;

import game.domain.overworld.entity.component.ai.behaviours.RandomRoaming;
import game.data.storage.entity.body.properties.EntityAIDescription;
import game.domain.overworld.entity.component.ai.behaviours.EntityBehaviourBase;
import game.domain.overworld.entity.component.ai.behaviours.SleepyPointGuard;
import game.domain.overworld.entity.component.ai.behaviours.FlowerPollinator;
import game.domain.overworld.entity.component.ai.behaviours.NpcQuestGiver;

class BehaviourFactory {

	public static function fromDesc( desc : EntityAIDescription ) : EntityBehaviourBase {
		return switch desc.type {
			case FLOWER_POLLINATOR: new FlowerPollinator( desc.params );
			case SLEEPY_POINT_GUARD: new SleepyPointGuard( desc.params );
			case RANDOM_ROAMING: new RandomRoaming( desc.params );
			case NPC_QUEST_GIVER: new NpcQuestGiver( desc.params );
		}
	}
}
