package game.core.rules.overworld.entity.component.combat;

import game.data.storage.entity.body.properties.AttackListDescription;

class EntityAttackListComponent extends EntityComponent {

	public final attackListDesc : AttackListDescription;

	final attackComponents : Array<EntityAttackListItem>;

	public function new( description : AttackListDescription ) {
		super( description );
		this.attackListDesc = description;

		attackComponents = createAttackList();
	}

	function createAttackList() : Array<EntityAttackListItem> {
		var result = [
			for ( attackDesc in attackListDesc.attackList ) {
				new EntityAttackListItem( attackDesc );
			}
		];

		return result;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		for ( component in attackComponents ) {
			component.attachToEntity( entity );
		}
	}
}
