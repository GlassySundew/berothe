package game.data.storage.entity.body.properties;

import game.domain.overworld.entity.component.model.stat.EntityDefenceStat;
import game.net.entity.EntityComponentReplicatorBase;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.domain.overworld.entity.component.EntityFlyComponent;

class EntityFlyingDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb( distance : Float ) : EntityFlyingDescription {
		if ( distance == 0 ) return null;
		return new EntityFlyingDescription( distance );
	}

	public final distance : Float;

	public function new( distance : Float ) {
		super( "flying_comp" );
		this.distance = distance;
		isReplicable = false;
	}

	public function buildComponent() : EntityComponent {
		return new EntityFlyComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
