package game.data.storage.entity.model;

import util.Assert;

enum abstract EntityEquipmentSlotType( String ) {

	var EQUIP_HEAD;
	var EQUIP_NECK;
	var EQUIP_HAND_RIGHT;
	var EQUIP_HAND_PALM_RIGHT;
	var EQUIP_HAND_LEFT;
	var EQUIP_HAND_PALM_LEFT;
	var EQUIP_WAIST;
	var EQUIP_LEG_RIGHT;
	var EQUIP_LEG_LEFT;

	#if !debug inline #end
	public static function fromCdb( type : Data.EquipItemType ) : EntityEquipmentSlotType {
		var id = type.id;
		if ( id == null && type is String ) {
			id = cast type;
		}
		var key = switch id {
			case head: EQUIP_HEAD;
			case neck: EQUIP_NECK;
			case hand_right: EQUIP_HAND_RIGHT;
			case hand_palm_right: EQUIP_HAND_PALM_RIGHT;
			case hand_left: EQUIP_HAND_LEFT;
			case hand_palm_left: EQUIP_HAND_PALM_LEFT;
			case waist: EQUIP_WAIST;
			case leg_right: EQUIP_LEG_RIGHT;
			case leg_left: EQUIP_LEG_LEFT;
		}

		#if debug
		Assert.notNull( key, "failed to recognize equipment type: " + type );
		#end

		return key;
	}
}
