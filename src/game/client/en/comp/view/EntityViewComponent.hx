package game.client.en.comp.view;

import hrt.prefab.Object3D;
import rx.disposables.Composite;
import core.MutableProperty;
import rx.disposables.ISubscription;
import dn.Cooldown;
import future.Future;
import graphics.ObjectNode3D;
import h3d.scene.Object;
import game.client.en.comp.view.IEntityView;
import game.data.storage.entity.body.view.EntityViewDescription;
import game.data.storage.entity.body.view.IEntityViewProvider.EntityViewExtraInitSetting;
import game.domain.overworld.entity.EntityComponent;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.location.Location;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
#if client
import game.client.en.comp.view.ui.EntityStatusBarContainer;
import game.client.en.comp.view.ui.EntitySleepSpeech;
import game.net.client.GameClient;
#end

class EntityViewComponent extends EntityComponent {

	public var view( default, null ) : Future<IEntityView> = new Future();
	public final cooldown : Cooldown = new Cooldown( hxd.Timer.wantedFPS );
	public final isBatched : MutableProperty<Bool> = new MutableProperty();
	var statusBar3dPoint : Object;
	final viewDescription : EntityViewDescription;

	#if client
	public final statusBarFuture : Future<EntityStatusBarContainer> = new Future();
	#end

	var viewExtraConfig : Array<EntityViewExtraInitSetting> = [];

	var subscription : Composite;

	public function new( viewDescription : EntityViewDescription ) {
		super( viewDescription );
		this.viewDescription = viewDescription;
	}

	override function dispose() {
		super.dispose();
		view.result?.dispose();
		cooldown.reset();

		subscription?.unsubscribe();
		#if client
		statusBarFuture.result?.root.remove();
		#end
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
		if ( view.result != null ) {
			dispose();
			view = new Future();
		}

		subscription?.unsubscribe();
		subscription = Composite.create();

		var viewGraphics = createView();
		if ( viewGraphics == null ) return;
		view.resolve( viewGraphics );

		var maybeSub = entity.components.onAppear(
			EntityModelComponent,
			( cl, modelComp ) -> {
				createStatusBar( modelComp );
				EntitySleepSpeech.subscribe( this );
				updateStatusBar3DPointPosition();
			}
		);
		if ( maybeSub != null ) subscription.add( maybeSub );

		var node = view.result.getGraphics();
		subscribeMoving( node );
		addViewToScene( node );
	}

	function subscribeMoving( node : ObjectNode3D ) {
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
		var maybeSub = entity.components.onAppear(
			EntityDynamicsComponent,
			( _, dynamics ) -> subscription.add( entity.onFrame.add( ( e, q ) -> onMove() ) )
		);
		if ( maybeSub != null ) subscription.add( maybeSub );
		onMove();
	}

	function addViewToScene( node : ObjectNode3D ) {
		if ( !isBatched.val ) {
			Boot.inst.root3D.addChild( node );
			return;
		}

		view.result.batcherize();
	}

	function createStatusBar( modelComp : EntityModelComponent ) {
		statusBar3dPoint = new Object();
		var viewResult = view.result;
		viewResult.addChildObject( ObjectNode3D.fromHeaps( statusBar3dPoint ) );
		var statusBar = new EntityStatusBarContainer( statusBar3dPoint, this );
		statusBarFuture.resolve( statusBar );
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
		modelComp.statusMessages.subscribe( statusBar.setChatMessage );

		inline function checkEnemy() {
			statusBar.setFriendliness(
				!modelComp.isEnemy( GameClient.inst.controlledEntity.val.entity.result )
			);
		}
		modelComp.factions.onChanged.add( ( _, _ ) -> checkEnemy() );
		checkEnemy();
	}

	function updateStatusBar3DPointPosition() {
		statusBar3dPoint.z = hxd.Math.clamp(
			view.result.getGraphics().heapsObject.getBounds().zMax, 0, 100
		) + 3;
	}
	#end
}
