package game.net.entity.component.model.skills;

import hxGeomAlgo.CCLabeler.Connectivity;
import game.data.storage.skill.SkillDescription.SkillType;
import net.NSIntMap.NSEnumMap;
import game.domain.overworld.entity.skills.EntityAdditiveStatSkillBase;
import util.Assert;
import net.NSClassMap;
import game.domain.overworld.entity.component.model.skills.EntitySkillContainer;
import net.NetNode;

class EntitySkillsReplicator extends NetNode {

	@:s public final skills : NSEnumMap<
		EntityAdditiveStatSkillReplicator,
		SkillType> = new NSEnumMap();

	var skillsContainer : EntitySkillContainer;

	public function new( skillsContainer : EntitySkillContainer, ?parent ) {
		super( parent );
		this.skillsContainer = skillsContainer;
	}

	public function followEntityServer( entityRepl : EntityReplicator ) {
		skillsContainer.container.stream.observe( onSkillAdded );
	}

	public function followEntityClient( entity : EntityReplicator ) {
		skills.subscribleWithMapping( ( classType, component ) -> {
			Assert.notNull( component );
		} );
	}

	function onSkillAdded( skill : EntityAdditiveStatSkillBase ) {
		var skillRepl = new EntityAdditiveStatSkillReplicator( skill, this );

		Assert.isFalse( skills.exists( untyped skill.classType.__clid ) );

		skills[skill.desc.type] = skillRepl;
	}
}
