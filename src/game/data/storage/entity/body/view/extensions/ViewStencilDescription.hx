package game.data.storage.entity.body.view.extensions;

import game.client.en.comp.view.extensions.ViewStencil;
import game.net.entity.EntityComponentReplicatorBase;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

enum StencilPresetType {
	Obstacle;
	Objective;
}

class ViewStencilDescription extends EntityComponentDescription {

	public static inline function fromCdb(
		entry : Data.EntityView_viewComps_stencil
	) : ViewStencilDescription {
		if ( entry == null ) return null;

		var presetType : StencilPresetType = switch entry.type {
			case Objective: Objective;
			case Obstacle: Obstacle;
		}

		return new ViewStencilDescription( presetType );
	}

	public final type : StencilPresetType;

	public function new( type : StencilPresetType ) {
		super( "stencil" );
		this.type = type;
	}

	public function buildComponent() : EntityComponent {
		return new ViewStencil( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
