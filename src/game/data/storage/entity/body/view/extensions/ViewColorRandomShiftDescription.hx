package game.data.storage.entity.body.view.extensions;

import game.data.storage.entity.component.EntityComponentDescription;

class ViewColorRandomShiftDescription extends EntityComponentDescription {

	public static inline function fromCdb(
		entry : Data.EntityView_viewComps_colorRandomShift
	) : ViewColorRandomShiftDescription {
		if ( entry == null ) return null;

		return new ViewColorRandomShiftDescription( entry.radius );
	}

	public final radius : Int;

	public function new( radius : Int ) {
		super( "viewColorRandomShift" );

		this.radius = radius;
	}
}
