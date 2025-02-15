package game.net.entity.component.model.skills;

import net.NSIntMap.NSEnumMap;
import net.NetNode;
import util.Assert;
import game.data.storage.skill.SkillDescription.SkillType;
import game.domain.overworld.entity.component.model.skills.EntitySkillContainer;
import game.domain.overworld.entity.skills.EntityAdditiveStatSkillBase;

class EntitySkillsContainerReplicator extends NetNode {

	@:s public final skills : NSEnumMap<
		EntityAdditiveStatSkillReplicator,
		SkillType> = new NSEnumMap();

	var skillsContainer : EntitySkillContainer;

	public function new( skillsContainer : EntitySkillContainer, ?parent ) {
		super( parent );
		this.skillsContainer = skillsContainer;
		skillsContainer.container.stream.observe( onSkillAdded );
	}

	public function followClient( skillsContainer : EntitySkillContainer ) {
		this.skillsContainer = skillsContainer;
		skills.subscribleWithMapping( ( classType, skill ) -> {
			Assert.notNull( skill );

			skillsContainer.add( skill.skill );
		} );
	}

	function onSkillAdded( skill : EntityAdditiveStatSkillBase ) {
		var skillRepl = new EntityAdditiveStatSkillReplicator( skill, this );

		Assert.isFalse( skills.exists( untyped skill.classType.__clid ) );

		trace( "creating skill replicator" );

		skills[skill.desc.type] = skillRepl;
	}
}
