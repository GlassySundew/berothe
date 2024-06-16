package game.core.rules.overworld.entity;

import game.data.storage.entity.body.EntityBodyDescription;

class EntityComponentsFactory {

	public static function fromPropertyDescription(
		bodyDescription : EntityBodyDescription
	) : Array<EntityComponent> {
		var result = [];

		for ( property in bodyDescription.propertyDescriptions ) {
			result.push( property.buildComponennt() );
		}

		return result;
	}
}
