package game.data.storage.entity.body.properties;

import game.data.storage.entity.component.EntityComponentDescription;

/**
	компонент, который описывает сущность-точку, которая существует только
	для того чтобы повесить на неё последнее сообщение, потом 
	сущность будет уничтожена
**/
class DeathMessageDescription extends EntityComponentDescription {

	public function new() {
		super( "deathMessage" );
	}
}
