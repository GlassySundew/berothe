package game.client.en.comp.view;

import game.client.en.comp.view.anim.WalkAnimationState;
import game.core.rules.overworld.entity.component.EntityDynamicsComponent;
import game.data.storage.entity.body.view.EntityAnimations;
import game.client.en.comp.view.anim.AnimationState;
import game.data.storage.entity.body.view.AnimationKey;
import plugins.bodyparts_animations.src.customObj.EntityComposer;
import graphics.ThreeDObjectNode;

class EntityComposerView implements IEntityView {

	final entityComposer : EntityComposer;
	final object : ThreeDObjectNode;
	final stateListeners : Map<AnimationKey, AnimationState> = [];
	final viewComponent : EntityViewComponent;

	final animations : EntityAnimations;
	final file : String;

	var dynamics( default, null ) : EntityDynamicsComponent;

	public function new(
		viewComponent : EntityViewComponent,
		file : String,
		animations : EntityAnimations
	) {
		this.viewComponent = viewComponent;
		this.animations = animations;
		this.file = file;

		var prefabSource = Std.downcast( hxd.Res.load( file ).toPrefab().load(), EntityComposer );
		entityComposer = prefabSource.make();
		object = ThreeDObjectNode.fromHeapsObject( entityComposer.local3d );

		viewComponent.entity.onFrame.add( ( dt, tmod ) -> {
			entityComposer?.animationManager.update( dt );

			for ( key => listener in stateListeners ) {
				if ( listener.listener() ) {
					playAnimation(
						key,
						listener.getSpeed() / tmod
					);
				}
			}
		} );

		viewComponent.entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamics ) -> this.dynamics = dynamics
		);

		initListeners();
	}

	public function getGraphics() : ThreeDObjectNode {
		return object;
	}

	function playAnimation( animationKey : AnimationKey, ?speed : Float ) {
		for ( animation in animations.byKey[animationKey] ) {
			var animationContainer = entityComposer.animationManager.animationGroups[animation];
			if ( animationContainer == null ) {
				trace( 'cannot find animation node with id: $animation in enco: $file ' );
				continue;
			}
			animationContainer.setPlay( true, speed );
		}
	}

	function initListeners() {
		if ( animations.byKey.get( IDLE ) != null ) {
			stateListeners[IDLE] = new AnimationState( idleListener );
		}
		if ( animations.byKey.get( WALK ) != null ) {
			stateListeners[WALK] = new WalkAnimationState( viewComponent.entity, walkListener );
		}
	}

	inline function walkListener() : Bool {
		return dynamics?.isMovementApplied;
	}

	inline function idleListener() : Bool {
		return !dynamics?.isMovementApplied.val;
	}
}
