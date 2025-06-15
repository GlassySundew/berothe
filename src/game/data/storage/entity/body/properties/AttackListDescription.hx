package game.data.storage.entity.body.properties;

import game.data.storage.entity.component.EntityComponentDescription;

class AttackListDescription extends EntityComponentDescription {

	public inline static function fromCdb(
		attackDesc : Data.EntityPropertySetup_properties_attack
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

}
