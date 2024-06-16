package en.comp;

@:noCompletion
class EntityComponent implements IEntityComponent<EntityComponent> {

	public final classType : Class<EntityComponent>;

	public final entity : Entity;

	public function new( entity : Entity ) {
		classType = Type.getClass( this );
		this.entity = entity;
	}
}
