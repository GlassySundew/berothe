package game.core.rules.overworld.entity.component.view;

import game.core.rules.overworld.location.Location;
import game.data.storage.entity.body.view.IEntityView.EntityViewInitializationSetting;
import game.data.storage.entity.body.view.EntityViewDescription;

class EntityViewComponent extends EntityComponent {

	final viewDescription : EntityViewDescription;

	var viewExtraConfig : EntityViewInitializationSetting = None;

	public function new( viewDescription : EntityViewDescription ) {
		super( viewDescription );
		this.viewDescription = viewDescription;
	}

	public function provideExtraViewConfig( config : EntityViewInitializationSetting ) {
		viewExtraConfig = config;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		#if client
		entity.location.onAppear( onAttachedToLocation );
		#end
	}

	#if client
	function createView() : graphics.ThreeDObjectNode {
		return viewDescription.viewProvider?.createView( viewExtraConfig );
	}

	function onAttachedToLocation( location : Location ) {
		var node = createView();

		// Boot.inst.root3D.addChild( node );
		if ( node != null ) {
			node.setPosition( entity.transform.x, entity.transform.y, entity.transform.z );
			@:privateAccess Boot.inst.s3d.addChild( node.heapsObject );
		}
	}
	#end
}
