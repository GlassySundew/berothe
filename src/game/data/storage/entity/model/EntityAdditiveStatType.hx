package game.data.storage.entity.model;

import haxe.exceptions.NotImplementedException;
import game.domain.overworld.entity.component.model.stat.EntityAttackStat;
import game.domain.overworld.entity.component.model.stat.EntityAdditiveStatBase;

enum abstract EntityAdditiveStatType( Int ) {

	var ATTACK;
	var DEFENCE;

	#if !debug inline #end
	public static function fromCdb( type : Data.EntityAdditiveStat ) : EntityAdditiveStatType {
		return switch type.id {
			case attack: ATTACK;
			case defence: DEFENCE;
		}
	}

	#if !debug inline #end
	public static function build( type : EntityAdditiveStatType, amount : Int ) : EntityAdditiveStatBase {
		return switch type {
			case ATTACK: new EntityAttackStat( amount );
			case DEFENCE: throw new NotImplementedException();
		}
	}
}
