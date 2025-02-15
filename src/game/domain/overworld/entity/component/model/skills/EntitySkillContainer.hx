package game.domain.overworld.entity.component.model.skills;

import signals.Signal;
import net.NSMutableProperty;
import util.Assert;
import game.domain.overworld.entity.skills.EntityAdditiveStatSkillBase;
import core.ClassMap;

class EntitySkillContainer {

	public final container : ClassMap<
		Class<EntityAdditiveStatSkillBase>,
		EntityAdditiveStatSkillBase> = new ClassMap();
	public final onAnySkillChanged = new Signal();

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
		Assert.notNull( skill );
		Assert.notExistsInClassMap( skill.classType, container );
		#end

		skill.xp.addOnValueImmediately(
			( _, _ ) -> onAnySkillChanged.dispatch()
		);

		skill.attachToEntity( entity );
		container[skill.classType] = skill;
	}

	public inline function isEmpty() : Bool {
		return container.isEmpty();
	}
}
