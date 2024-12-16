package game.data.storage.entity.body.view.extensions;

import game.client.en.comp.view.extensions.ViewPaletteSwap;
import cdb.Types.ArrayRead;
import game.net.entity.EntityComponentReplicatorBase;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
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

	public function buildComponent() : EntityComponent {
		return new ViewPaletteSwap( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
