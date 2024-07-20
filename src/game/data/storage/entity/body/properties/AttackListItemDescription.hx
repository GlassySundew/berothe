package game.data.storage.entity.body.properties;

import game.core.rules.overworld.entity.component.combat.EntityAttackListItem;
import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.data.storage.entity.body.view.AnimationKey;
import game.data.storage.entity.body.view.AttackTranslationTween;
import game.core.rules.overworld.entity.EntityComponent;

class AttackListItemDescription {

	public static function fromCdb(
		attack : Data.EntityProperty_properties_attackDesc_attackList
	) : AttackListItemDescription {
		return new AttackListItemDescription(
			AnimationKey.fromCdb( attack.key ),
			AttackTranslationTween.fromCdb( attack.tweenType ),
			attack.offsetX,
			attack.offsetY,
			attack.offsetZ,
			attack.sizeX,
			attack.sizeY,
			attack.sizeZ,
			attack.cooldown,
			attack.duration,
			attack.endX,
			attack.id.toString(),
		);
	}

	public final key : AnimationKey;
	public final transition : AttackTranslationTween;
	public final cooldown : Float;
	public final duration : Float;
	public final endX : Float;
	public final tweenType : AttackTranslationTween;

	public final offsetX : Float = 0;
	public final offsetY : Float = 0;
	public final offsetZ : Float = 0;
	public final sizeX : Float = 0;
	public final sizeY : Float = 0;
	public final sizeZ : Float = 0;

	public final id : String;

	public inline function new(
		key : AnimationKey,
		tweenType : AttackTranslationTween,
		offsetX : Float,
		offsetY : Float,
		offsetZ : Float,
		sizeX : Float,
		sizeY : Float,
		sizeZ : Float,
		cooldown : Float,
		duration : Float,
		endX : Float,
		id : String
	) {

		this.id = id;

		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.offsetZ = offsetZ;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;

		this.tweenType = tweenType;
		this.transition = tweenType;
		this.key = key;
		this.cooldown = cooldown;
		this.duration = duration;
		this.endX = endX;
	}
}
