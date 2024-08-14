package game.client.en.comp.view;

import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.EntityComponent;
import dn.M;
import game.client.en.comp.view.IEntityView;
import game.domain.overworld.location.Location;
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
		return viewDescription.viewProvider?.createView( this, viewExtraConfig );
	}

	function onAttachedToLocation( location : Location ) {
		view = createView();

		if ( view == null ) return;

		var node = view.getGraphics();
		Boot.inst.root3D.addChild( node );

		node.setPosition( entity.transform.x, entity.transform.y, entity.transform.z );

		entity.components.onAppear(
			EntityDynamicsComponent,
			( _, dynamics ) -> {
				dynamics.onMove.add(() -> {
					node.setRotation(
						entity.transform.rotationX,
						entity.transform.rotationY,
						entity.transform.rotationZ
					);
					node.setPosition(
						entity.transform.x,
						entity.transform.y,
						entity.transform.z
					);
				} );
			} );
	}
	#end
}
