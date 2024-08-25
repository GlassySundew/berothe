package game.data.storage.item;

import game.net.entity.component.EntityPickableComponentReplicator;
import game.domain.overworld.entity.component.EntityPickableComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityPickablePropertyDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityProperty_properties_pickable
	) : EntityPickablePropertyDescription {
		if ( entry == null ) return null;
		return new EntityPickablePropertyDescription(
			entry.item.id.toString(),
			entry.id.toString()
		);
	}

	public final itemDescId : String;

	public function new( itemDescId : String, id : String ) {
		super( id );
		this.itemDescId = itemDescId;
	}

	public function buildComponennt() : EntityComponent {
		return new EntityPickableComponent( this );
	}

	public function buildCompReplicator( ?parent ) : EntityComponentReplicatorBase {
		return new EntityPickableComponentReplicator( parent );
	}
}
