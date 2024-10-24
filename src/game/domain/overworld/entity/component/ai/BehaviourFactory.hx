package game.domain.overworld.entity.component.ai;

import game.data.storage.entity.body.properties.EntityAIDescription;
import game.domain.overworld.entity.component.ai.behaviours.EntityBehaviourBase;
import game.domain.overworld.entity.component.ai.behaviours.SleepyPointGuard;

class BehaviourFactory {

	public static function fromDesc( desc : EntityAIDescription ) : EntityBehaviourBase {
		return switch desc.type {
			case SLEEPY_POINT_GUARD: new SleepyPointGuard( desc.params[0] );
		}
	}
}
