package game.data.storage.entity.body.properties;

import tink.CoreApi.Lazy;
import game.domain.overworld.entity.component.EntityInteractableComponent;
import game.data.storage.entity.body.properties.action.BodyActionBase;
import game.data.storage.entity.body.properties.action.ActionsFactory;
import net.NetNode;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.net.entity.component.EntityInteractableReplicator;

typedef ItemRequirement = {
	itemDescId : String,
	breakChance : Float
}

class InteractableDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb(
		cdbEntry : Data.EntityPropertySetup_properties_interactable
	) : InteractableDescription {
		if ( cdbEntry == null ) return null;

		return new InteractableDescription(
			cdbEntry.tooltipLocale,
			cdbEntry.actionsQueue == null ? [] : //
				[for ( action in cdbEntry.actionsQueue ) {
					ActionsFactory.fromCdb( action.action );
				}],
			cdbEntry.itemRequired?.itemId.toString(),
			cdbEntry.itemRequired?.removeChance,
			cdbEntry.id.toString(),
		);
	}

	public final actionQueue : Array<Lazy<BodyActionBase>>;
	public final tooltipLocale : Null<String>;
	public final itemRequired : ItemRequirement;

	public function new(
		?tooltipLocale : Null<String>,
		actionQueue : Array<Lazy<BodyActionBase>>,
		?itemRequiredId : Null<String>,
		?itemRequiredBreakChance : Null<Float>,
		id : String
	) {
		super( id );
		this.tooltipLocale = tooltipLocale;
		this.actionQueue = actionQueue;

		itemRequired = itemRequiredId == null ? null : {
			itemDescId : itemRequiredId,
			breakChance : itemRequiredBreakChance ?? 0
		};
	}

	public function buildComponent() : EntityComponent {
		return new EntityInteractableComponent( this );
	}

	public function buildCompReplicator(
		?parent : NetNode
	) : EntityComponentReplicatorBase {
		return new EntityInteractableReplicator( parent );
	}
}
