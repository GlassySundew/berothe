package game.domain.overworld.entity.component;

import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.data.storage.entity.body.properties.DeathMessageDescription;

class EntityDeathMessageComponent extends EntityComponent {

	public function providePrecedingEntity( entityPrec : OverworldEntity ) {
		var predecessorModelComp = entityPrec.components.get( EntityModelComponent );
		var msg = predecessorModelComp.statusMessages.at( -1 );

		var modelComp = this.entity.components.get( EntityModelComponent );
		modelComp.provideMsgVO( msg );
		for ( predFaction in predecessorModelComp.factions.iterator() ) {
			modelComp.factions.push( predFaction );
		}

		modelComp.statusMessages.onChanged.add( ( _, _ ) -> this.entity.invalidateDispose() );
	}
}
