package game.domain.overworld.entity.component.model.stat;

class EntityAttackStat extends EntityAdditiveStatBase {

	public function new( ?amount : Float = 1 ) {
		super( ATTACK, amount );
	}
}
