package game.domain.overworld.entity.skills;

import game.data.storage.skill.SkillDescription;

abstract class EntityAdditiveStatSkillBase {

	public final classType : Class<EntityAdditiveStatSkillBase>;

	public var xp( default, null ) : Float;
	public var level( default, null ) : Int;

	public final desc : SkillDescription;

	public function new( desc : SkillDescription ) {
		this.desc = desc;
		classType = Type.getClass( this );
	}

	public function dispose() {

	}

	public function attachToEntity( entity : OverworldEntity ) {

	}
}
