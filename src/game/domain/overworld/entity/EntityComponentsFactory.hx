package game.domain.overworld.entity;

import game.data.storage.entity.body.EntityPropertiesDescription;

class EntityComponentsFactory {

	public static function fromPropertyDescription(
		bodyDescription : EntityPropertiesDescription
	) : Array<EntityComponent> {
		var result = [];

		for ( property in bodyDescription.propertyDescriptions ) {
			result.push( property.buildComponennt() );
		}

		return result;
	}
}
