package game.net.entity;

import future.Future;
import game.core.rules.overworld.location.Location;
import game.data.storage.DataStorage;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityReplicator extends NetNode {

	public var entity( default, null ) : Future<OverworldEntity> = new Future();

	@:s public final transformRepl : EntityTransformReplicator;
	@:s public final componentsRepl : EntityComponentsReplicator;
	
	@:s var entityDescriptionId : String;
	@:s var locationDescId : String;

	public function new( entity : OverworldEntity, ?parent ) {
		super( parent );
		this.entity.resolve( entity );
		entityDescriptionId = entity.desc.id.toString();

		transformRepl = new EntityTransformReplicator( this );
		transformRepl.followEntityServer( entity );

		componentsRepl = new EntityComponentsReplicator( this );
		componentsRepl.followEntityServer( entity );

		entity.location.addOnValueImmediately( onLocationChanged );
	}

	override function alive() {
		super.alive();

		var desc = DataStorage.inst.entityStorage.getDescriptionById( entityDescriptionId );
		var entityLocal = new OverworldEntity( desc, "0" ); // todo client ids
		componentsRepl.followEntityClient( entityLocal );
		transformRepl.followEntityClient( entityLocal );
		
		entity.resolve( entityLocal );
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer, finalize : Bool = false ) {
		if ( finalize ) componentsRepl = null;

		super.unregister( host, ctx, finalize );
	}

	function onLocationChanged( _, location : Location ) {
		locationDescId = location?.locationDesc.id.toString();
	}
}
