package game.domain.overworld.entity.skills;

import game.domain.overworld.entity.component.model.stat.EntityMaxHpStat;
import game.domain.overworld.entity.component.model.EntityModelComponent;

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

	override function attachToEntity( entity : OverworldEntity ) {
		var maxHpStat = new EntityMaxHpStat( Std.int( getPoints() ) );
		var modelComponent = entity.components.get( EntityModelComponent );
		modelComponent.stats.maxHp.addStat( maxHpStat );

		level.addOnValue( ( _, newVal ) -> {
			maxHpStat.amount = getPoints();
			modelComponent.stats.maxHp.recalculate();
		} );
	}
}
