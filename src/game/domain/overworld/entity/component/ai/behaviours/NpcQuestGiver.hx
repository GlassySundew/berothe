package game.domain.overworld.entity.component.ai.behaviours;

import haxe.exceptions.NotImplementedException;
import game.net.server.GameServer;
import game.data.storage.npcResponses.NpcResponseType;
import game.data.storage.npcResponses.NpcActivationTriggerType;
import rx.disposables.Composite;
import rx.disposables.ISubscription;
import util.Assert;
import game.client.en.comp.view.EntityMessageVO;
import game.data.storage.DataStorage;
import game.data.storage.npcResponses.NpcResponseDescription;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.domain.overworld.entity.skills.AdditiveStatSkillFactory;

class NpcQuestGiver extends EntityBehaviourBase {

	static final FOCUS_TIMEOUT_DELAY_ID = "questgiver_delay";
	static final FOCUS_TIMEOUT_SECONDS = 13;
	static final INTERACTION_DISTANCE = 65;
	static final UNFOCUS_DISTANCE = 85;

	var currentFocus : Null<OverworldEntity>;

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
			someEntity -> {
				entitySubscriptions[someEntity]?.unsubscribe();
				entitySubscriptions.remove( someEntity );
				if ( someEntity == currentFocus ) unfocusFromEntity( someEntity );
			}
		) );

		subscribeSurroundingChunksForEntityMovement( onSomeEntityMoved );
	}

	inline function onEntityAdded( someEntity : OverworldEntity ) {
		if ( someEntity == entity ) return;

		var model = someEntity.components.get( EntityModelComponent );
		if ( model == null ) return;
		entitySubscriptions[someEntity] = //
			model.statusMessages.onChanged.add( onSomeEntitySaidSomething.bind( someEntity ) );
	}

	inline function onSomeEntityMoved( someEntity : OverworldEntity ) {
		if ( someEntity == entity ) return;

		var isEligible = checkEligibleForFocus( someEntity );
		if ( !isEligible ) return;

		var currentChain = getCurrentChain( someEntity );
		if (
			someEntity == currentFocus
			&& currentChain != null
			&& doesChainContainTurningAway( someEntity, null, currentChain ) //
		) {
			entity.transform.turnAwayFrom( someEntity );
			return;
		}

		if ( someEntity == currentFocus ) {
			entity.transform.turnTowardsTo( someEntity );
			if ( entity.transform.distToEntity2D( someEntity ) > UNFOCUS_DISTANCE )
				unfocusFromEntity( someEntity );
			return;
		}

		triggerOnApproach( someEntity );
		checkChainProgressions( someEntity );
	}

	inline function onSomeEntitySaidSomething( someEntity : OverworldEntity, i, msg : EntityMessageVO ) {
		if ( msg == null ) return;

		var isEligible = checkEligibleForFocus( someEntity );
		if ( !isEligible ) return;

		var hasRefocused = someEntity != currentFocus;
		focusOnEntity( someEntity );
		triggerOnSpeech( someEntity, msg.message, hasRefocused );
		checkChainProgressions( someEntity );
	}

	inline function focusOnEntity( someEntity : OverworldEntity ) {
		entity.delayer.cancelById( FOCUS_TIMEOUT_DELAY_ID );
		entity.delayer.addS(
			FOCUS_TIMEOUT_DELAY_ID,
			() -> unfocusFromEntity( someEntity ),
			FOCUS_TIMEOUT_SECONDS
		);

		entity.transform.turnTowardsTo( someEntity );
		currentFocus = someEntity;

		onSomeEntityMoved( someEntity );
	}

	inline function unfocusFromEntity( someEntity : OverworldEntity ) {
		Assert.equals( someEntity, currentFocus );
		entity.delayer.cancelById( FOCUS_TIMEOUT_DELAY_ID );
		var currentChain = getCurrentChain( someEntity );
		performActions( someEntity, currentChain.unfocusActions );
		currentFocus = null;
	}

	inline function doesChainContainTurningAway(
		someEntity : OverworldEntity,
		textSaid : Null<String>,
		currentChain : NpcResponseChainElement
	) {
		var result = false;
		for ( refocusAction in currentChain.refocusActions ) {
			if ( //
				refocusAction.actions.contains( TURN_AWAY_FROM_PLAYER )
				&& areRequirementsFulfilled( someEntity, textSaid, refocusAction.triggers ) //
			) {
				result = true;
				break;
			}
		}
		return result;
	}

	inline function checkEligibleForFocus( someEntity : OverworldEntity ) : Bool {
		if ( currentFocus == someEntity ) return true;
		if ( currentFocus != null || someEntity == entity ) return false;
		if ( !someEntity.components.has( EntityModelComponent ) ) return false;
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
		for ( action in currentChain.refocusActions ) {
			if ( action.triggers.contains( TRIGGER_ON_APPROACH ) ) {
				performActions( someEntity, action.actions );
				focusOnEntity( someEntity );
				break;
			}
		}
	}

	function triggerOnSpeech( someEntity : OverworldEntity, text : String, hasRefocused : Bool ) {
		var currentChain = getCurrentChain( someEntity );
		Assert.notNull( currentChain );

		if ( hasRefocused ) {
			// refocusing
			for ( refocusAction in currentChain.refocusActions ) {
				if ( areRequirementsFulfilled( someEntity, text, refocusAction.triggers ) ) {
					performActions( someEntity, refocusAction.actions );
					return;
				}
			}
			performActions( someEntity, currentChain.chatRestActions );
		} else {
			for ( chainAdvance in currentChain.chainAdvancements ) {
				if ( areRequirementsFulfilled( someEntity, text, chainAdvance.requirements ) ) {
					progressChainTo( someEntity, chainAdvance, chainAdvance.nextChainId );
					trace( "triggered speech, advancing to " + chainAdvance );
					return;
				}
			}
			for ( action in currentChain.actions ) {
				if ( areRequirementsFulfilled( someEntity, text, action.triggers ) ) {
					performActions( someEntity, action.actions );
					return;
				}
			}

			performActions( someEntity, currentChain.chatRestActions );
		}
	}

	/**
		checks chain progessions without requirements
	**/
	inline function checkChainProgressions( someEntity : OverworldEntity ) {
		var currentChain = getCurrentChain( someEntity );
		for ( chainProgress in currentChain.chainAdvancements )
			if ( areRequirementsFulfilled( someEntity, chainProgress.requirements ) ) {
				progressChainTo( someEntity, chainProgress, chainProgress.nextChainId );
				break;
			}
	}

	inline function progressChainTo(
		someEntity : OverworldEntity,
		trigger : ChainAdvanceTrigger,
		chainId : String
	) {
		performActions( someEntity, trigger.completionActions );
		interactorsMemory[someEntity.id] = chainId;
		onSomeEntityMoved( someEntity );
	}

	#if !debug inline #end
	function performActions(
		someEntity : OverworldEntity,
		actions : Array<NpcResponseType>
	) {
		for ( action in actions ) {
			switch action {
				case SAY( localeId ):
					model.purgeStatusBar();
					model.sayText(
						Data.locale.resolve( localeId ).text
					);
				case GIVE_QUEST( questId ):
				case TURN_AWAY_FROM_PLAYER:
				case GENERATE_ITEM( itemDescId, amount ):
					var item = GameServer.inst.core.itemFactory.createItem(
						DataStorage.inst.itemStorage.getById( itemDescId )
					);
					item.amount.val = amount;
					model.inventory.dropItemInFront( item );
				case UNFOCUS: unfocusFromEntity( someEntity );
				case GRANT_SKILL( skillDescId ):
					var focusEntModel = currentFocus.components.get( EntityModelComponent );
					var skill = AdditiveStatSkillFactory.fromDescription(
						DataStorage.inst.skillStorage.getById( skillDescId )
					);
					focusEntModel.skills.add( skill );

					// skill.
					// focusEntModel.
			}
		}
	}

	#if !debug inline #end
	function areRequirementsFulfilled(
		someEntity : OverworldEntity,
		?textSaid : Null<String>,
		requirements : Array<NpcActivationTriggerType>
	) {
		var result = requirements.length == 0 ? true : false;
		for ( req in requirements ) {
			switch req {
				case TRIGGER_ON_APPROACH: result = result && true;
				case TEXT_SAID( awaitSpeechId ):
					if ( textSaid == null ) {
						result = result && false;
						continue;
					}
					var speechAwaitEntry = Data.npcAwaitSpeech.resolve( awaitSpeechId );

					var isSpeechFulfilled = false;
					for ( speechAwait in speechAwaitEntry.samples ) {
						if ( StringTools.contains( textSaid, speechAwait.text ) ) {
							isSpeechFulfilled = true;
						}
					}
					result = result || isSpeechFulfilled;
				case QUEST_COMPLETED( questId ): throw new NotImplementedException();
				case HAS_ITEM( itemId, amount ): throw new NotImplementedException();
			}
		}
		return result;
	}
}
