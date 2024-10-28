package game.domain.overworld.entity;

import game.data.storage.entity.component.EntityComponentDescription;

abstract class EntityComponent {

	public final classType : Class<EntityComponent>;
	public final description : EntityComponentDescription;

	public var entity( default, null ) : OverworldEntity;
	public var isOwned( default, null ) : Bool = false;

	public function new( description : EntityComponentDescription ) {
		classType = Type.getClass( this );
		this.description = description;
	}

	public function claimOwnage() : Void {
		isOwned = true;
	}

	public function dispose() {}

	@:allow( game.domain.overworld.entity.EntityComponents )
	function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
	}
}
