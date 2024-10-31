package game.data.storage.entity.body.view.extensions;

import game.client.en.comp.view.extensions.ViewColorRandomShift;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import net.NetNode;
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

	public function buildComponent() : EntityComponent {
		return new ViewColorRandomShift( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
