package game.data.storage.entity.body.properties;

import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.entity.component.combat.EntityAttackListComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.component.EntitySimpleComponentReplicator;

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

	public function buildCompReplicator( ?parent ) : EntitySimpleComponentReplicator {
		return new EntitySimpleComponentReplicator( parent );
	}
}
