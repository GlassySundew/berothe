package game.domain.overworld.entity;

import game.data.storage.entity.component.EntityComponentDescription;
import game.data.storage.entity.body.EntityPropertiesDescription;

class EntityComponentsFactory {

	public static function fromPropertyDescriptions(
		bodyDescriptions : Array<EntityComponentDescription>
	) : Array<EntityComponent> {
		var result = [];

		for ( property in bodyDescriptions ) {
			result.push( property.buildComponennt() );
		}

		return result;
	}
}
