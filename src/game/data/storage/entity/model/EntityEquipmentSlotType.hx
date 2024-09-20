package game.data.storage.entity.model;

import util.Assert;

enum abstract EntityEquipmentSlotType( String ) from String to String {

	var EQUIP_HEAD;
	var EQUIP_NECK;
	var EQUIP_HAND_MAIN;
	var EQUIP_HAND_PALM_MAIN;
	var EQUIP_HAND_SECO;
	var EQUIP_HAND_PALM_SECO;
	var EQUIP_WAIST;
	var EQUIP_LEG_RIGHT;
	var EQUIP_LEG_LEFT;

	public inline static function fromCdb( type : Data.EquipItemType ) : EntityEquipmentSlotType {
		var key = switch type.id {
			case head: EQUIP_HEAD;
			case neck: EQUIP_NECK;
			case hand_main: EQUIP_HAND_MAIN;
			case hand_seco: EQUIP_HAND_SECO;
			case waist: EQUIP_WAIST;
			case hand_palm_main: EQUIP_HAND_PALM_MAIN;
			case hand_palm_seco: EQUIP_HAND_PALM_SECO;
			case leg_right: EQUIP_LEG_RIGHT;
			case leg_left: EQUIP_LEG_LEFT;
		}

		#if debug
		Assert.notNull( key, "failed to recognize equipment type: " + type );
		#end

		return key;
	}
}
