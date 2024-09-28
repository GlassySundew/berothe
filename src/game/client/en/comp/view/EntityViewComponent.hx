package game.client.en.comp.view;

import future.Future;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.location.Location;

class EntityViewComponent extends EntityComponent {

	public final view : Future<IEntityView> = new Future();

	final viewDescription : EntityViewDescription;

	var viewExtraConfig : EntityViewExtraInitSetting = None;

	public function new( viewDescription : EntityViewDescription ) {
		super( viewDescription );
		this.viewDescription = viewDescription;
	}

	override function dispose() {
		super.dispose();
		view.result?.dispose();
	}

	public function provideExtraViewConfig( config : EntityViewExtraInitSetting ) {
		viewExtraConfig = config;
	}

	#if client
	public function addChildComponent( childView : IEntityView ) {
		view.then( ( viewResult ) -> {
			viewResult.addChildView( childView );
		} );
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		entity.location.onAppear( onAttachedToLocation );
	}

	function createView() : IEntityView {
		return viewDescription.viewProvider?.createView( this, viewExtraConfig );
	}

	function onAttachedToLocation( location : Location ) {

		if ( view == null ) return;

		view.resolve( createView() );
		var node = view.result.getGraphics();
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
			}
		);
	}
	#end
}
