package game.net.entity.component.model.skills;

import game.domain.overworld.entity.skills.EntityAdditiveStatSkillBase;
import net.NetNode;

class EntityAdditiveStatSkillReplicator extends NetNode {

	public final skill : EntityAdditiveStatSkillBase;

	public function new( skill : EntityAdditiveStatSkillBase, ?parent ) {
		super( parent );
		this.skill = skill;
	}

	override function alive() {
		super.alive();
		trace( "aliving skill" );
	}
}
