package game.domain.overworld.entity.component.model.skills;

import util.Assert;
import game.domain.overworld.entity.skills.EntityAdditiveStatSkillBase;
import core.ClassMap;

class EntitySkillContainer {

	public final container : ClassMap<Class<EntityAdditiveStatSkillBase>, EntityAdditiveStatSkillBase> = new ClassMap();

	final entity : OverworldEntity;

	public function new( entity : OverworldEntity ) {
		this.entity = entity;
	}

	public function dispose() {
		for ( skill in container ) {
			skill.dispose();
		}
	}

	public function add( skill : EntityAdditiveStatSkillBase ) {
		#if debug
		Assert.notExistsInClassMap( skill, container );
		#end

		skill.attachToEntity( entity );
		container[skill.classType] = skill;
	}
}
