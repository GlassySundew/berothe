package game.core.rules.overworld.entity.component.combat;

import oimo.collision.geometry.BoxGeometry;
import game.data.storage.entity.body.properties.AttackListDescription.AttackListItemDescription;

class EntityAttackComponent extends EntityComponent {

	final attackDescription : AttackListItemDescription;
	

	public function new( desc : AttackListItemDescription ) {
		super( desc );
		this.attackDescription = desc;

		var geom : BoxGeometry;

		
	}

	
}
