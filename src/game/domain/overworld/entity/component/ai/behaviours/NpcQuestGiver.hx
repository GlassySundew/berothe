package game.domain.overworld.entity.component.ai.behaviours;

import util.GameUtil;
import game.domain.overworld.entity.component.model.EntityStats;
import rx.disposables.ISubscription;
import rx.disposables.Composite;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import util.Assert;
import game.data.storage.DataStorage;
import game.data.storage.npcResponses.NpcResponseDescription;

class NpcQuestGiver extends EntityBehaviourBase {

	static final INTERACTION_DISTANCE = 35;

	var currentFocus : OverworldEntity;

	final responses : NpcResponseDescription;

	/** player id -> current chain id **/
	final interactorsMemory : Map<String, String> = [];
	final entryChainId : String;
	final susbcribtion = Composite.create();
	final entitySubscriptions : Map<OverworldEntity, ISubscription> = [];

	public function new( params ) {
		super( params );

		Assert.notNull( params.npcResponsesId, "response chain for npc " + entity + " is not defined" );
		Assert.notNull( params.npcResponseEntryChainId, "entry chain element for npc " + entity + " is not defined" );

		responses = DataStorage.inst.npcResponsesStorage.getById( params.npcResponsesId );
		entryChainId = params.npcResponseEntryChainId;
	}

	override function dispose( _ ) {
		super.dispose( _ );
		susbcribtion.unsubscribe();
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		susbcribtion.add( entity.location.getValue().onEntityAdded.add( onEntityAdded ) );
		susbcribtion.add( entity.location.getValue().onEntityRemoved.add(
			someEntity -> entitySubscriptions[someEntity].unsubscribe()
		) );

		subscribeSurroundingChunksForEntityMovement( onSomeEntityMoved );
	}

	inline function onEntityAdded( someEntity : OverworldEntity ) {
		if ( someEntity == entity ) return;

		var model = someEntity.components.get( EntityModelComponent );
		entitySubscriptions[someEntity] = model.statusMessages.onChanged.add( onSomeEntitySaidSomething.bind( someEntity ) );
	}

	inline function onSomeEntityMoved( someEntity : OverworldEntity ) {
		if ( someEntity == entity ) return;
		var currentChain = getCurrentChain( someEntity );
		if ( currentChain != null
			&& currentChain.actions.contains( TURN_AWAY_FROM_PLAYER ) //
		) {
			entity.transform.turnAwayFrom( someEntity );
			return;
		}

		if ( someEntity == currentFocus ) {
			entity.transform.turnTowardsTo( someEntity );
		}

		var isEligible = checkEligibleForFocus( someEntity );
		if ( !isEligible ) return;

		triggerOnApproach( someEntity );
		currentFocus = someEntity;
	}

	inline function onSomeEntitySaidSomething( someEntity : OverworldEntity, i, msg ) {
		if ( msg == null ) return;

		checkEligibleForFocus( someEntity );
	}

	inline function checkEligibleForFocus( someEntity : OverworldEntity ) : Bool {
		if ( currentFocus != null || someEntity == entity ) return false;
		if ( entity.transform.distToEntity2D( someEntity ) > INTERACTION_DISTANCE ) return false;

		// todo loading from db
		if ( interactorsMemory[someEntity.id] == null )
			interactorsMemory[someEntity.id] = entryChainId;

		return true;
	}

	inline function getCurrentChain(
		someEntity : OverworldEntity
	) : Null<NpcResponseChainElement> {
		var chainId = interactorsMemory[someEntity.id];
		return chainId == null ? null : responses.chainsById[chainId];
	}

	inline function containsEnum<T : EnumValue>( value : T, enums : Array<T> ) {}

	inline function triggerOnApproach( someEntity : OverworldEntity ) {
		var currentChain = getCurrentChain( someEntity );
		Assert.notNull( currentChain );
		if ( currentChain.activationTriggers.contains( TRIGGER_ON_APPROACH ) ) {
			performChainAction( currentChain );
		}
	}

	inline function triggerOnSpeech( someEntity : OverworldEntity, text : String ) {}

	inline function performChainAction( chain : NpcResponseChainElement ) {
		for ( action in chain.actions ) {
			switch action {
				case SAY( localeId ):
					model.sayText(
						Data.locale.resolve( localeId ).text
					);
				case GIVE_QUEST( questId ):
				case TURN_AWAY_FROM_PLAYER:
			}
		}
	}
}
