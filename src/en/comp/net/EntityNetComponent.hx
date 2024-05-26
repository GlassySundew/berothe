package en.comp.net;

class EntityNetComponent extends net.NetNode implements IEntityComponent<EntityNetComponent> {

	public final classType : Class<EntityNetComponent>;

	@:s var entity : Entity;

	public function new( entity : Entity, ?parent ) {
		classType = Type.getClass( this );
		this.entity = entity;
		super( parent );
	}
}
