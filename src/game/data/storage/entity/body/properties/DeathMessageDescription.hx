package game.data.storage.entity.body.properties;

import game.domain.overworld.entity.component.EntityDeathMessageComponent;
import game.net.entity.EntityComponentReplicatorBase;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;

/**
	компонент, который описывает сущность-точку, которая существует только
	для того чтобы повесить на неё последнее сообщение, потом 
	сущность будет уничтожена
**/
class DeathMessageDescription extends EntityComponentDescription {

	public function new() {
		super( "deathMessage" );
		isReplicable = false;
	}

	public function buildComponent() : EntityComponent {
		return new EntityDeathMessageComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
