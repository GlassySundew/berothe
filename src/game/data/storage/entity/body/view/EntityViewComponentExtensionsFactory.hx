package game.data.storage.entity.body.view;

import game.data.storage.entity.body.view.extensions.ViewColorRandomShiftDescription;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityViewComponentExtensionsFactory {

	public static inline function fromCdb(
		entry : Data.EntityView_viewComps
	) : Array<EntityComponentDescription> {
		var result : Array<EntityComponentDescription> = [];

		if ( entry.colorRandomShift != null ) {
			result.push( ViewColorRandomShiftDescription.fromCdb( entry.colorRandomShift ) );
		}

		return result;
	}
}
