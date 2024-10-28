package game.data.storage.entity.model;

import game.domain.overworld.entity.component.model.stat.EntityWeaponRangeStat;
import haxe.exceptions.NotImplementedException;
import game.domain.overworld.entity.component.model.stat.EntityAttackStat;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

enum abstract EntityAdditiveStatType( Int ) {

	var ATTACK;
	var DEFENCE;
	var WEAPON_RANGE;
	var SPEED;

	#if !debug inline #end
	public static function fromCdb( type : Data.EntityAdditiveStat ) : EntityAdditiveStatType {
		return switch type.id {
			case attack: ATTACK;
			case defence: DEFENCE;
			case weaponRange: WEAPON_RANGE;
			case speed: SPEED;
		}
	}

	#if !debug inline #end
	public static function build( type : EntityAdditiveStatType, amount : Int ) : EntityAdditiveStatBase {
		return switch type {
			case ATTACK: new EntityAttackStat( amount );
			case DEFENCE: throw new NotImplementedException();
			case WEAPON_RANGE: new EntityWeaponRangeStat( amount );
			case SPEED: new EntityWeaponRangeStat( amount );
		}
	}
}
