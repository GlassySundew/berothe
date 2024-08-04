package game.client.en.comp.view;

import game.client.en.comp.view.anim.AttackAnimationState;
import game.core.rules.overworld.entity.component.combat.EntityAttackListItem;
import game.core.rules.overworld.entity.component.combat.EntityAttackListComponent;
import game.client.en.comp.view.anim.WalkAnimationState;
import game.core.rules.overworld.entity.component.EntityDynamicsComponent;
import game.data.storage.entity.body.view.EntityAnimations;
import game.client.en.comp.view.anim.AnimationState;
import game.data.storage.entity.body.view.AnimationKey;
import plugins.bodyparts_animations.src.customObj.EntityComposer;
import graphics.ThreeDObjectNode;

class EntityComposerView implements IEntityView {

	static final attackKeyList = [
		{ idle : ATTACK_PRIME_IDLE, active : ATTACK_PRIME_ATTACK },
		{ idle : ATTACK_SECO_IDLE, active : ATTACK_SECO_ATTACK }
	];

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
						listener,
						tmod
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

	function playAnimation( animationKey : AnimationKey, listener : AnimationState, tmod : Float ) {
		for ( animation in animations.byKey[animationKey].keys ) {
			var animationContainer = entityComposer.animationManager.animationGroups[animation];
			if ( animationContainer == null ) {
				trace( 'cannot find animation node with id: $animation in enco: $file ' );
				continue;
			}
			animationContainer.setPlay( true, listener.getSpeed() / tmod );
			listener.playedOnContainer( animationContainer );
		}
	}

	function initListeners() {
		if ( animations.byKey.get( IDLE ) != null ) {
			stateListeners[IDLE] = new AnimationState( idleListener );
		}
		if ( animations.byKey.get( WALK ) != null ) {
			stateListeners[WALK] = new WalkAnimationState( viewComponent.entity, walkListener );
		}
		viewComponent.entity.components.onAppear(
			EntityAttackListComponent,
			( cl, component ) -> {
				for ( attackAnimItem in attackKeyList ) {
					if ( animations.byKey.get( attackAnimItem.idle ) != null ) {
						var attackItem = component.getItemByAnimationKey( attackAnimItem.active );
						stateListeners[attackAnimItem.idle] = new AnimationState( attackIdleListener.bind( attackItem ) );
					}
					if ( animations.byKey.get( attackAnimItem.active ) != null ) {
						var attackItem = component.getItemByAnimationKey( attackAnimItem.active );
						stateListeners[attackAnimItem.active] = new AttackAnimationState( attackItem );
					}
				}
			}
		);
	}

	inline function walkListener() : Bool {
		return dynamics?.isMovementApplied;
	}

	inline function idleListener() : Bool {
		return !dynamics?.isMovementApplied.val;
	}

	inline function attackIdleListener( attackItem : EntityAttackListItem ) : Bool {
		return !attackItem.isAttacking();
	}
}
