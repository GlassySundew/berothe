package game.data.storage.skill;

class SkillDescriptionStorage extends DescriptionStorageBase<SkillDescription, Data.Skill> {

	override function parseItem( entry : Data.Skill ) {
		addItem( SkillDescription.fromCdb( entry ) );
	}
}
