package game.domain.overworld.entity.component.model.stat;

class EntityMaxHpStat extends EntityAdditiveStatBase {

	public function new( ?amount : Int = 1 ) {
		super( MAX_HP, amount );
	}
}
