package game.client.en.comp.view;

import game.domain.overworld.entity.component.model.EntityModelComponent;
import haxe.exceptions.NotImplementedException;
import core.NodeBase;
import graphics.ObjectNode3D;
import plugins.bodyparts_animations.src.customObj.EntityComposer;
import util.Assert;
import game.client.en.comp.view.anim.AnimationState;
import game.client.en.comp.view.anim.AttackAnimationState;
import game.client.en.comp.view.anim.WalkAnimationState;
import game.data.storage.entity.body.view.AnimationKey;
import game.data.storage.entity.body.view.EntityAnimations;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.domain.overworld.entity.component.combat.EntityAttackListComponent;
import game.domain.overworld.entity.component.combat.EntityAttackListItem;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;

class EntityComposerView extends NodeBase<EntityComposerView> implements IEntityView {

	static final attackKeyList = [
		{
			idle : ATTACK_RIGHT_IDLE,
			raised : ATTACK_RIGHT_RAISED,
			active : ATTACK_RIGHT_ATTACK
		},
		{
			idle : ATTACK_LEFT_IDLE,
			raised : ATTACK_LEFT_RAISED,
			active : ATTACK_LEFT_ATTACK
		}
	];

	public final entityComposer : EntityComposer;
	final object : ObjectNode3D;
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
		super( null );
		this.viewComponent = viewComponent;
		this.animations = animations;
		this.file = file;

		var prefabSource = Std.downcast( hxd.Res.load( file ).toPrefab().load(), EntityComposer );
		entityComposer = prefabSource.make();
		object = ObjectNode3D.fromHeaps( entityComposer.local3d );

		viewComponent.entity.onFrame.add( update );

		viewComponent.entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamics ) -> this.dynamics = dynamics
		);

		initListeners();
	}

	public function dispose() {
		object.remove();
	}

	public function getGraphics() : ObjectNode3D {
		return object;
	}

	public inline function provideSize( vec : ThreeDeeVector ) {
		object.heapsObject.scaleX = vec.x;
		object.heapsObject.scaleY = vec.y;
		object.heapsObject.scaleZ = vec.z;
	}

	public function addChildView( view : IEntityView ) {
		addChildObject( view.getGraphics() );

		switch Type.getClass( view ) {
			case EntityComposerView:
				addChild( Std.downcast( view, EntityComposerView ) );

			case EntityStaticBoxView: throw new NotImplementedException();
		}
	}

	public function addChildObject( object : ObjectNode3D ) @:privateAccess {
		getGraphics().heapsObject.children[0].addChild( object.heapsObject );
	}

	function update( dt, tmod ) {
		if ( entityComposer.animationManager == null ) {
			trace( "animation manager keeps being null" );
			return;
		}

		entityComposer.animationManager.update( dt );

		for ( key => listener in stateListeners ) {
			if ( listener.listener() ) {
				playAnimation(
					key,
					listener,
					tmod
				);
			}
		}
	}

	function playAnimation( animationKey : AnimationKey, listener : AnimationState, tmod : Float ) {
		var animationDesc = animations.byKey[animationKey];
		Assert.notNull(
			animationDesc,
			"animation node: " + animationKey + " not found in file: " + file
		);
		for ( animation in animationDesc.keys ) {
			var animationContainer = entityComposer.animationManager.animationGroups[animation];
			if ( animationContainer == null ) {
				trace( 'cannot find animation node with id: $animation in enco: $file ' );
				continue;
			}
			animationContainer.setPlay( true, animationDesc.speedMult * listener.getSpeed() / 15 * tmod );
			listener.playedOnContainer( animationContainer );

			for ( child in children ) {
				if ( child.animations.byKey[animationKey] != null ) {
					child.playAnimation( animationKey, listener, tmod );
				}
			}
		}
	}

	function initListeners() {
		if ( animations.byKey.get( IDLE ) != null ) {
			stateListeners[IDLE] = new AnimationState( idleListener );
		}
		if ( animations.byKey.get( WALK ) != null ) {
			stateListeners[WALK] = new WalkAnimationState(
				viewComponent.entity,
				walkListener,
				animations.byKey[WALK].isAffectedByStats
			);
		}
		viewComponent.entity.components.onAppear(
			EntityAttackListComponent,
			( cl, component ) -> {
				for ( attackAnimItem in attackKeyList ) {
					var attackItem = component.getItemByAnimationKey( attackAnimItem.active );
					if ( attackItem == null ) continue;

					if ( animations.byKey.get( attackAnimItem.idle ) != null ) {
						stateListeners[attackAnimItem.idle] = new AnimationState( attackIdleListener.bind( attackItem ) );
					}
					if ( animations.byKey.get( attackAnimItem.raised ) != null ) {
						stateListeners[attackAnimItem.raised] = new AnimationState( attackRaisedListener.bind( attackItem ) );
					}
					if ( animations.byKey.get( attackAnimItem.active ) != null ) {
						stateListeners[attackAnimItem.active] = new AttackAnimationState( attackItem );
					}
				}
			}
		);
		viewComponent.entity.components.onAppear(
			EntityModelComponent,
			( cl, modelComp ) -> {
				if ( animations.byKey.get( SLEEP ) != null ) {
					stateListeners[SLEEP] = new AnimationState( sleepListener.bind( modelComp ) );
				}
				if ( animations.byKey.get( AWAKE ) != null ) {
					stateListeners[AWAKE] = new AnimationState( awakeListener.bind( modelComp ) );
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
		return !attackItem.isAttacking() && !attackItem.isRaised.getValue();
	}

	inline function attackRaisedListener( attackItem : EntityAttackListItem ) : Bool {
		return !attackItem.isAttacking() && attackItem.isRaised.getValue();
	}

	inline function sleepListener( modelComp : EntityModelComponent ) : Bool {
		return modelComp.isSleeping.getValue();
	}

	inline function awakeListener( modelComp : EntityModelComponent ) : Bool {
		return !modelComp.isSleeping.getValue();
	}
}
