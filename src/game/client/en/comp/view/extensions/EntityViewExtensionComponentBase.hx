package game.client.en.comp.view.extensions;

import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.EntityComponent;

class EntityViewExtensionComponentBase extends EntityComponent {

	var viewComp : EntityViewComponent;

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );
		entity.components.onAppear(
			EntityViewComponent,
			( cl, viewComp ) -> {
				this.viewComp = viewComp;
				onViewCompAppeared();
			}
		);
	}

	function onViewCompAppeared() {}
}