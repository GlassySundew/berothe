package game.data.storage.entity.model;

import util.Assert;

enum abstract EntityEquipmentType( String ) from String to String {

	var EQUIP_HAND_MAIN;
	var EQUIP_HAND_SECO;
	var EQUIP_HEAD;
	var EQUIP_LEGS;
	var EQUIP_WAIST;
	var EQUIP_NECK;

	public inline static function fromCdb( type : Data.EquipItemType ) : EntityEquipmentType {
		var key = switch type.id {
			case equip_hand_main: EQUIP_HAND_MAIN;
			case equip_hand_seco: EQUIP_HAND_SECO;
			case equip_head: EQUIP_HEAD;
			case equip_legs: EQUIP_LEGS;
			case equip_waist: EQUIP_WAIST;
		}

		#if debug
		Assert.notNull( key, "failed to recognize equipment type: " + type );
		#end

		return key;
	}
}
