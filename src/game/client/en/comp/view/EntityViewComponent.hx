package game.client.en.comp.view;

import graphics.ObjectNode3D;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
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

	var viewExtraConfig : Array<EntityViewExtraInitSetting> = [];

	public function new( viewDescription : EntityViewDescription ) {
		super( viewDescription );
		this.viewDescription = viewDescription;
	}

	override function dispose() {
		super.dispose();
		view.result?.dispose();
	}

	public function provideExtraViewConfig( config : EntityViewExtraInitSetting ) {
		viewExtraConfig.push( config );
	}

	#if client
	public function addChildComponent( childView : IEntityView ) {
		view.then( ( viewResult ) -> {
			viewResult.addChildView( childView );
		} );
	}

	public function addChildObject( object : ObjectNode3D ) {
		view.then( ( viewResult ) -> {
			viewResult.addChildObject( object );
		} );
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		entity.location.onAppear( onAttachedToLocation );
	}

	function createView() : IEntityView {
		var view = viewDescription.viewProvider?.createView( this, viewExtraConfig );
		if ( view == null ) return null;

		for ( setting in viewExtraConfig ) {
			switch setting {
				case Size( x, y, z ):
					view.provideSize( new ThreeDeeVector( x, y, z ) );
				default:
			}
		}

		return view;
	}

	function onAttachedToLocation( location : Location ) {
		if ( view == null ) return;
		var viewGraphics = createView();
		if ( viewGraphics == null ) return;
		
		view.resolve( viewGraphics );
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
