package game.core.rules.overworld.entity.component.combat;

import game.data.storage.entity.body.properties.AttackListDescription;

class EntityAttackListComponent extends EntityComponent {

	public final attackListDesc : AttackListDescription;

	final components : Array<EntityAttackComponent>;

	public function new( description : AttackListDescription ) {
		super( description );
		this.attackListDesc = description;

		components = createComponents();
	}

	function createComponents() : Array<EntityAttackComponent> {
		var result = [
			for ( attackDesc in attackListDesc.attackList ) {
				Std.downcast( attackDesc.buildComponennt(), EntityAttackComponent );
			}
		];

		return result;
	}
}
