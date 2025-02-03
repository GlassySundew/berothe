package game.domain.overworld.entity.skills;

import game.data.storage.skill.SkillDescription;

class AdditiveStatSkillFactory {

	public static function fromDescription( desc : SkillDescription ) : EntityAdditiveStatSkillBase {
		return switch desc.type {
			case LIFE: new LifeSkill( desc );
		}
	}
}
