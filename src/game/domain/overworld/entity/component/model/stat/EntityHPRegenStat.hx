package game.domain.overworld.entity.component.model.stat;

class EntityHPRegenStat extends EntityAdditiveStatBase {

	public function new( ?amount : Float = 1 ) {
		super( HP_REGEN, amount );
	}
}
