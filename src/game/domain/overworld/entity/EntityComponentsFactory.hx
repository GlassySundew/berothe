package game.domain.overworld.entity;

import game.data.storage.entity.component.EntityComponentDescription;

class EntityComponentsFactory {

	public static function fromPropertyDescriptions(
		bodyDescriptions : Array<EntityComponentDescription>
	) : Array<EntityComponent> {
		var result = [];

		// for ( property in bodyDescriptions ) {
		// 	if ( property != null ) result.push( property.buildComponent() );
		// }

		return result;
	}
}
