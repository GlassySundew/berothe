package game.domain.overworld.entity.component.model.stat;

class EntitySpeedStat extends EntityAdditiveStatBase {

	public function new( ?amount = 1. ) {
		super( SPEED, amount );
	}
}
