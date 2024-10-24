package game.client.en.comp.view;

import dn.Cooldown;
import future.Future;
import graphics.ObjectNode3D;
import h3d.scene.Object;
import game.client.en.comp.view.IEntityView;
import game.client.en.comp.view.ui.EntitySleepSpeech;
import game.client.en.comp.view.ui.EntityStatusBarContainer;
import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

class EntityViewComponent extends EntityComponent {

	public final view : Future<IEntityView> = new Future();
	public final cooldown : Cooldown = new Cooldown( hxd.Timer.wantedFPS );
	final statusBar3dPoint = new Object();
	final viewDescription : EntityViewDescription;

	public var statusBar( default, null ) : EntityStatusBarContainer;

	var viewExtraConfig : Array<EntityViewExtraInitSetting> = [];

	public function new( viewDescription : EntityViewDescription ) {
		super( viewDescription );
		this.viewDescription = viewDescription;
	}

	override function dispose() {
		super.dispose();
		view.result?.dispose();
		statusBar?.root.remove();
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
		entity.onFrame.add( ( dt, tmod ) -> cooldown.update( tmod ) );
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

		viewGraphics.addChildObject( ObjectNode3D.fromHeaps( statusBar3dPoint ) );
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

		updateStatusBar3DPointPosition();

		entity.components.onAppear(
			EntityModelComponent,
			( cl, modelComp ) -> {
				createStatusBar( modelComp );
				EntitySleepSpeech.subscribe( this );
			}
		);
	}

	function createStatusBar( modelComp : EntityModelComponent ) {
		statusBar = new EntityStatusBarContainer( statusBar3dPoint, this );
		Main.inst.root.add( statusBar.root, util.Const.DP_UI_NICKNAMES );
		modelComp.displayName.addOnValueImmediately(
			( oldVal, newVal ) -> {
				statusBar.setDisplayNameVisibility( newVal != null && newVal != "" );
				statusBar.setDisplayName( newVal );
			}
		);
	}

	function updateStatusBar3DPointPosition() {
		statusBar3dPoint.z = view.result.getGraphics().heapsObject.getBounds().zMax + 5;
	}
	#end
}
