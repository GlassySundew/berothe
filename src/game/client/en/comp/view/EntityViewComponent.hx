package game.client.en.comp.view;

import rx.disposables.Composite;
import core.MutableProperty;
import rx.disposables.ISubscription;
import dn.Cooldown;
import future.Future;
import graphics.ObjectNode3D;
import h3d.scene.Object;
import game.client.en.comp.view.IEntityView;
import game.client.en.comp.view.ui.EntityStatusBarContainer;
import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
#if client
import game.client.en.comp.view.ui.EntitySleepSpeech;
#end

class EntityViewComponent extends EntityComponent {

	public var view( default, null ) : Future<IEntityView> = new Future();
	public final cooldown : Cooldown = new Cooldown( hxd.Timer.wantedFPS );
	public final isBatched : MutableProperty<Bool> = new MutableProperty();
	final statusBar3dPoint = new Object();
	final viewDescription : EntityViewDescription;

	public var statusBar( default, null ) : EntityStatusBarContainer;

	var viewExtraConfig : Array<EntityViewExtraInitSetting> = [];

	var subscription : Composite;

	public function new( viewDescription : EntityViewDescription ) {
		super( viewDescription );
		this.viewDescription = viewDescription;
	}

	override function dispose() {
		super.dispose();
		view.result?.dispose();

		subscription?.unsubscribe();
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
		subscription?.unsubscribe();
		subscription = Composite.create();

		if ( view.result != null ) {
			view.result.dispose();
			view = new Future();
		}
		var viewGraphics = createView();
		if ( viewGraphics == null ) return;
		view.resolve( viewGraphics );
		var node = view.result.getGraphics();

		addViewToScene( node );

		function onMove() {
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
		}
		entity.components.onAppear(
			EntityDynamicsComponent,
			( _, dynamics ) -> subscription.add( dynamics.onMove.add( onMove ) )
		);
		onMove();

		entity.components.onAppear(
			EntityModelComponent,
			( cl, modelComp ) -> {
				viewGraphics.addChildObject( ObjectNode3D.fromHeaps( statusBar3dPoint ) );
				createStatusBar( modelComp );
				EntitySleepSpeech.subscribe( this );
				updateStatusBar3DPointPosition();
			}
		);
	}

	function addViewToScene( node : ObjectNode3D ) {
		if ( !isBatched.val ) {
			Boot.inst.root3D.addChild( node );
			return;
		}

		view.result.batcherize();
	}

	function createStatusBar( modelComp : EntityModelComponent ) {
		statusBar = new EntityStatusBarContainer( statusBar3dPoint, this );
		Main.inst.root.add( statusBar.root, util.Const.DP_UI_NICKNAMES );
		modelComp.displayName.addOnValueImmediately(
			( oldVal, newVal ) -> {
				statusBar.setDisplayNameVisibility(
					!modelComp.desc.hideNameByDefault
					&& (
						newVal != null
						&& newVal != ""
					)
				);
				statusBar.setDisplayName( newVal );
			}
		);
		modelComp.onDamaged.add( ( damage, type ) -> {
			statusBar.sayChatMessage( Std.string( damage ) );
		} );
	}

	function updateStatusBar3DPointPosition() {
		statusBar3dPoint.z = view.result.getGraphics().heapsObject.getBounds().zMax + 5;
	}
	#end
}
