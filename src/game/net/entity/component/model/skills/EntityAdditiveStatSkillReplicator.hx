package game.net.entity.component.model.skills;

import game.domain.overworld.entity.skills.AdditiveStatSkillFactory;
import game.data.storage.DataStorage;
import net.NSMutableProperty;
import game.domain.overworld.entity.skills.EntityAdditiveStatSkillBase;
import net.NetNode;

class EntityAdditiveStatSkillReplicator extends NetNode {

	public var skill( default, null ) : EntityAdditiveStatSkillBase;

	@:s public final xp : NSMutableProperty<Float>;
	@:s public final level : NSMutableProperty<Int>;

	@:s final skillDescId : String;

	public function new( skill : EntityAdditiveStatSkillBase, ?parent ) {
		this.skill = skill;
		xp = new NSMutableProperty<Float>();
		level = new NSMutableProperty<Int>();
		skillDescId = skill.desc.id;

		skill.level.subscribeProp( level );
		skill.xp.subscribeProp( xp );

		super( parent );
	}

	public function followClient() {}

	override function alive() {
		super.alive();

		var desc = DataStorage.inst.skillStorage.getById( skillDescId );
		skill = AdditiveStatSkillFactory.fromDescription( desc );
	}
}
