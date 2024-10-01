package game.data.storage.entity.model;

import util.Assert;

var typeConversion : Map<Data.EquipSlotTypeKind, EntityEquipmentSlotType> = //
	[
		//
		head => EQUIP_HEAD,
		neck => EQUIP_NECK,
		ring_right => EQUIP_RING_RIGHT,
		ring_left => EQUIP_RING_LEFT,
		hand_right => EQUIP_HAND_RIGHT,
		hand_palm_right => EQUIP_HAND_PALM_RIGHT,
		hand_left => EQUIP_HAND_LEFT,
		hand_palm_left => EQUIP_HAND_PALM_LEFT,
		waist => EQUIP_WAIST,
		leg_right => EQUIP_LEG_RIGHT,
		leg_left => EQUIP_LEG_LEFT,
	];

enum abstract EntityEquipmentSlotType( Int ) {

	var EQUIP_HEAD;
	var EQUIP_NECK;
	var EQUIP_RING_LEFT;
	var EQUIP_RING_RIGHT;
	var EQUIP_HAND_RIGHT;
	var EQUIP_HAND_PALM_RIGHT;
	var EQUIP_HAND_LEFT;
	var EQUIP_HAND_PALM_LEFT;
	var EQUIP_WAIST;
	var EQUIP_LEG_RIGHT;
	var EQUIP_LEG_LEFT;

	#if !debug inline #end
	public static function fromCdb( type : Data.EquipSlotType ) : EntityEquipmentSlotType {
		var id = type.id;
		if ( id == null && type is String ) {
			id = cast type;
		}
		var key = typeConversion[id];

		#if debug
		Assert.notNull( key, "failed to recognize equipment type: " + type,  );
		#end

		return key;
	}
}
