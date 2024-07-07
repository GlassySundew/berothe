package game.core.rules.overworld.entity.component.view;

import dn.M;
import game.client.en.comp.view.IEntityView;
import game.core.rules.overworld.location.Location;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;
import game.data.storage.entity.body.view.EntityViewDescription;

class EntityViewComponent extends EntityComponent {

	final viewDescription : EntityViewDescription;

	var viewExtraConfig : EntityViewExtraInitSetting = None;
	var view : IEntityView;

	public function new( viewDescription : EntityViewDescription ) {
		super( viewDescription );
		this.viewDescription = viewDescription;
	}

	public function provideExtraViewConfig( config : EntityViewExtraInitSetting ) {
		viewExtraConfig = config;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		#if client
		entity.location.onAppear( onAttachedToLocation );
		#end
	}

	#if client
	function createView() : IEntityView {
		return viewDescription.viewProvider?.createView( viewExtraConfig );
	}

	function onAttachedToLocation( location : Location ) {
		view = createView();

		if ( view == null ) return;

		var node = view.getGraphics();
		Boot.inst.root3D.addChild( node );

		node.setPosition( entity.transform.x, entity.transform.y, entity.transform.z );

		entity.onFrame.add( ( _ ) -> {
			var object = view.getGraphics();
			if ( object == null ) {
				trace( "view found to be null while synchronizing from entity" );
				return;
			}
			object.setPosition( entity.transform.x, entity.transform.y, entity.transform.z );


			entity.components.onAppear(
				EntityDynamicsComponent,
				( _, dynamics ) -> {
					dynamics.onMove.add(() -> {
						object.setRotation(
							entity.transform.rotationX,
							entity.transform.rotationY,
							entity.transform.rotationZ
						);
					} );
				} );
		} );
	}
	#end
}
