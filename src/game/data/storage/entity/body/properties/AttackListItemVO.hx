package game.data.storage.entity.body.properties;

import game.data.storage.entity.model.EntityEquipmentSlotType;
import game.domain.overworld.entity.component.combat.EntityAttackListItem;
import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.data.storage.entity.body.view.AnimationKey;
import game.data.storage.entity.body.view.AttackTranslationTween;
import game.domain.overworld.entity.EntityComponent;

class AttackListItemVO {

	public static function fromCdb(
		attack : Data.EntityProperty_properties_attack_attackList
	) : AttackListItemVO {
		return new AttackListItemVO(
			attack.id.toString(),
			AnimationKey.fromCdb( attack.key ),
			attack.cooldown,
			attack.duration,
			attack.baseAttack,
			attack.equipSlot == null ? null : EntityEquipmentSlotType.fromCdb( attack.equipSlot ),
			attack.endX,
			AttackTranslationTween.fromCdb( attack.tweenType ),
			attack.offsetX,
			attack.offsetY,
			attack.offsetZ,
			attack.sizeX,
			attack.sizeY,
			attack.sizeZ,
		);
	}

	public final id : String;
	public final key : AnimationKey;
	public final cooldown : Float;
	public final duration : Float;
	public final baseAttack : Int;

	public final tweenType : AttackTranslationTween;
	public final transition : AttackTranslationTween;

	public final offsetX : Float = 0;
	public final offsetY : Float = 0;
	public final offsetZ : Float = 0;
	public final sizeX : Float = 0;
	public final sizeY : Float = 0;
	public final sizeZ : Float = 0;
	public final endX : Float;
	public final equipSlotType : Null<EntityEquipmentSlotType>;

	public inline function new(
		id : String,
		key : AnimationKey,
		cooldown : Float,
		duration : Float,
		baseAttack : Int,
		equipSlotType : Null<EntityEquipmentSlotType>,
		endX : Float,
		tweenType : AttackTranslationTween,
		offsetX : Float,
		offsetY : Float,
		offsetZ : Float,
		sizeX : Float,
		sizeY : Float,
		sizeZ : Float
	) {
		this.id = id;

		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.offsetZ = offsetZ;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
		this.endX = endX;

		this.tweenType = tweenType;
		this.transition = tweenType;
		this.key = key;
		this.baseAttack = baseAttack;
		this.cooldown = cooldown;
		this.duration = duration;
		this.equipSlotType = equipSlotType;
	}
}
