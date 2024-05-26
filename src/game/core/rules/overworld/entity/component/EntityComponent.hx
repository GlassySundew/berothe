package game.core.rules.overworld.entity.component;

abstract class EntityComponent {

	public final classType : Class<EntityComponent>;

	public var entity( default, null ) : OverworldEntity;

	public function new() {
		classType = Type.getClass( this );
	}

	public function attachToEntity( entity : OverworldEntity ) {
		this.entity = entity;
	}
}
