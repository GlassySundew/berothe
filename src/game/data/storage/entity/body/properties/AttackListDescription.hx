package game.data.storage.entity.body.properties;

import game.core.rules.overworld.entity.component.combat.EntityAttackComponent;
import net.NetNode;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.component.combat.EntityAttackListComponent;
import game.data.storage.entity.body.view.AnimationKey;
import game.data.storage.entity.body.view.AttackTranslationTween;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.EntityComponentReplicatorBase;

class AttackListDescription extends EntityComponentDescription {

	public inline static function fromCdb(
		attackDesc : Data.EntityProperty_properties_attackDesc
	) : AttackListDescription {
		if ( attackDesc == null ) return null;

		var attackDescriptions = [
			for ( attackEntry in attackDesc.attackList )
				AttackListItemDescription.fromCdb( attackEntry )
		];

		return new AttackListDescription( attackDescriptions, attackDesc.id.toString() );
	}

	public final attackList : Array<AttackListItemDescription>;

	public function new(
		attackList : Array<AttackListItemDescription>,
		id : String
	) {
		super( id );
		this.attackList = attackList;
	}

	public function buildComponennt() : EntityComponent {
		return new EntityAttackListComponent( this );
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		// throw new haxe.exceptions.NotImplementedException();
		return null;
	}
}

class AttackListItemDescription extends VolumetricBodyDescriptionBase {

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
		super(
			offsetX,
			offsetY,
			offsetZ,
			sizeX,
			sizeY,
			sizeZ,
			id
		);

		this.transition = tweenType;
		this.key = key;
		this.cooldown = cooldown;
		this.duration = duration;
		this.endX = endX;
	}

	public function buildComponennt():EntityComponent {
		return new EntityAttackComponent(this);
	}

	public function buildCompReplicator(?parent:NetNode):EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
