package game.domain.overworld.entity.skills;

class LifeSkill extends EntityAdditiveStatSkillBase {

	// override atta
	public function getStatus() : String {
		return
			Data.locale.get( Data.LocaleKind.life_name ).text
				// todo focus ???
			+ ": "
			+ Data.locale.get( Data.LocaleKind.level ).text
			+ " "
			+ level.val
			+ " ("
			+ getPoints()
			+ " "
			+ Data.locale.get( Data.LocaleKind.life_hitpoints ).text
			+ ") ("
			+ xp.val / getXpReq() * 100
			+ "%)";
	}
}
