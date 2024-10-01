package game.domain.overworld.entity.component.model.stat;

class EntityAttackStat extends EntityAdditiveStatBase {

	public function new( ?amount = 1 ) {
		super( ATTACK, amount );
	}

	override public function attach( entity : OverworldEntity ) {
		super.attach( entity );
	}

	public function detach() {}
}
