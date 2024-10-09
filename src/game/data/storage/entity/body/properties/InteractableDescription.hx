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

class InteractableDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb(
		cdbEntry : Data.EntityProperty_properties_interactable
	) : InteractableDescription {
		if ( cdbEntry == null ) return null;

		return new InteractableDescription(
			cdbEntry.tooltipLocale,
			[for ( action in cdbEntry.actionsQueue ) {
				ActionsFactory.fromCdb( action.action );
			}],
			cdbEntry.id.toString()
		);
	}

	public final actionQueue : Array<Lazy<BodyActionBase>>;
	public final tooltipLocale : Null<String>;

	public function new(
		?tooltipLocale : Null<String>,
		actionQueue : Array<Lazy<BodyActionBase>>,
		id : String
	) {
		super( id );
		this.tooltipLocale = tooltipLocale;
		this.actionQueue = actionQueue;
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
