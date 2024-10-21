package game.data.storage.entity.body.properties;

import game.domain.overworld.entity.component.ai.EntityAIComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import net.NetNode;
import game.data.storage.entity.component.EntityComponentDescription;

class EntityAIDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb() : EntityAIDescription {
		return null;
	}

	public function new( id : String ) {
		super( id );
	}

	public function buildComponent() : EntityComponent {
		return new EntityAIComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
