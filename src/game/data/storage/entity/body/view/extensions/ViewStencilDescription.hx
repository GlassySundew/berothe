package game.data.storage.entity.body.view.extensions;

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
}
