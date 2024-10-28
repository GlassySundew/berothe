package game.data.storage.entity.body.properties;

import game.net.entity.component.attack.EntityAttackListReplicator;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.component.EntitySimpleComponentReplicator;

class AttackListDescription extends EntityComponentDescription {

	public inline static function fromCdb(
		attackDesc : Data.EntityProperty_properties_attack
	) : AttackListDescription {
		if ( attackDesc == null ) return null;
		var attackDescriptions = [
			for ( attackEntry in attackDesc.attackList )
				AttackListItemVO.fromCdb( attackEntry )
		];
		return new AttackListDescription( attackDescriptions, attackDesc.id.toString() );
	}

	public final attackList : Array<AttackListItemVO>;

	public function new(
		attackList : Array<AttackListItemVO>,
		id : String
	) {
		super( id );
		this.attackList = attackList;
	}

	public function buildComponent() : EntityComponent {
		return new EntityAttackListComponent( this );
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		return new EntityAttackListReplicator( parent );
	}
}
