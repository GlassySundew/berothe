package game.domain.overworld.entity.skills;

import core.MutableProperty;
import game.data.storage.skill.SkillDescription;

abstract class EntityAdditiveStatSkillBase {

	public final classType : Class<EntityAdditiveStatSkillBase>;

	public final xp = new MutableProperty<Float>();
	public final level = new MutableProperty<Int>( 1 );

	public final desc : SkillDescription;

	public function new( desc : SkillDescription ) {
		this.desc = desc;
		classType = Type.getClass( this );
	}

	public inline function getPoints() : Float {
		return desc.progression[level.val].points;
	}

	public inline function getXpReq() : Float {
		return desc.progression[level.val].xpReq;
	}

	abstract public function getStatus() : String;

	public function dispose() {}

	public function attachToEntity( entity : OverworldEntity ) {}
}
