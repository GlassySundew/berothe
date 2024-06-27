package game.net.entity;

import game.data.storage.DataStorage;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityReplicator extends NetNode {

	public var entity( default, null ) : OverworldEntity;

	@:s var componentsRepl : EntityComponentsReplicator;
	@:s var entityDescriptionId : String;
	var transformRepl : EntityTransformReplicator;

	public function new( entity : OverworldEntity, ?parent ) {
		super( parent );
		this.entity = entity;
		entityDescriptionId = entity.desc.id.toString();

		transformRepl = new EntityTransformReplicator( this );
		transformRepl.followEntity( entity );

		componentsRepl = new EntityComponentsReplicator( this );
		componentsRepl.followEntityServer( entity );
	}

	override function alive() {
		super.alive();

		var desc = DataStorage.inst.entityStorage.getDescriptionById( entityDescriptionId );
		entity = new OverworldEntity( desc, "0" ); // todo client ids
		componentsRepl.followEntityClient( entity );
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer, finalize : Bool = false ) {
		if ( finalize ) componentsRepl = null;

		super.unregister( host, ctx, finalize );
	}
}
