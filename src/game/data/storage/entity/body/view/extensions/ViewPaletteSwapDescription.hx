package game.data.storage.entity.body.view.extensions;

import cdb.Types.ArrayRead;
import game.data.storage.entity.component.EntityComponentDescription;

class ViewPaletteSwapDescription extends EntityComponentDescription {

	public static inline function fromCdb(
		entry : ArrayRead<Data.EntityView_viewComps_paletteSwap>
	) : ViewPaletteSwapDescription {
		if ( entry == null ) return null;

		var paletteMap : Map<Int, Int> = [];

		for ( i in entry ) {
			paletteMap[i.from] = i.to;
		}

		return new ViewPaletteSwapDescription( paletteMap );
	}

	public final paletteMap : Map<Int, Int>;

	public function new( paletteMap : Map<Int, Int> ) {
		super( "palette_swap" );

		this.paletteMap = paletteMap;
	}
}
