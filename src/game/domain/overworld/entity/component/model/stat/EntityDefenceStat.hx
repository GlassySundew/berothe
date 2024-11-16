package game.domain.overworld.entity.component.model.stat;

class EntityDefenceStat extends EntityAdditiveStatBase {

	public function new( ?amount = 1. ) {
		super( DEFENCE, amount );
	}
}