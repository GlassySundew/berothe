package game.domain.overworld.entity.component.model.stat;

class EntityWeaponRangeStat extends EntityAdditiveStatBase {

	public function new( ?amount = 1. ) {
		super( WEAPON_RANGE, amount );
	}
}
