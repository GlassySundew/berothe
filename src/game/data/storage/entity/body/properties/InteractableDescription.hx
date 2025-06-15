package game.data.storage.entity.body.properties;

import tink.CoreApi.Lazy;
import game.data.storage.entity.body.properties.action.ActionsFactory;
import game.data.storage.entity.body.properties.action.BodyActionBase;
import game.data.storage.entity.component.EntityComponentDescription;

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
}
