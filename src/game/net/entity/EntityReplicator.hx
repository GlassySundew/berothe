package game.net.entity;

#if server
import game.net.server.GameServer;
#end
import util.Repeater;
import future.Future;
import game.domain.overworld.location.Location;
import game.data.storage.DataStorage;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.NetNode;
import game.domain.overworld.entity.OverworldEntity;

class EntityReplicator extends NetNode {

	public var entity( default, null ) : Future<OverworldEntity> = new Future();

	@:s public final transformRepl : EntityTransformReplicator;
	@:s public final componentsRepl : EntityComponentsReplicator;
	@:s public final id : String;

	@:s var entityDescriptionId : String;
	@:s var locationDescId : String;

	public function new( entity : OverworldEntity, ?parent ) {
		super( parent );

		this.entity.resolve( entity );
		entityDescriptionId = entity.desc.id.toString();
		id = entity.id;

		transformRepl = new EntityTransformReplicator( this );
		transformRepl.followEntityServer( entity );

		componentsRepl = new EntityComponentsReplicator( this );
		componentsRepl.followEntityServer( entity );

		entity.location.addOnValueImmediately( onLocationChanged );

		entity.disposed.then( onEntityUnregister );
	}

	override public function unregister( host : NetworkHost, ?ctx ) {
		super.unregister( host, ctx );
		transformRepl.unregister( host, ctx );
		componentsRepl.unregister( host, ctx );

		trace( "unregistering entity " + entity.result );
	}

	#if client
	override function onUnregisteredClient() {
		super.onUnregisteredClient();
		entity.result.dispose();
	}
	#end

	function onEntityUnregister( ?v ) {
		// entity has to be disconnected ONLY AFTER it was detached from chunk
		entity.result.chunk.addOnValue(
			( oldChunk, newChunk ) -> {
				if ( newChunk != null ) throw "setting new chunk for disposed entity";
				onEntityDisposed();
			}
		);

		trace( entity.result.chunk.getValue() );
	}

	@:rpc( clients )
	function test() {
		trace( entity.result, __host );
	}

	override function alive() {
		super.alive();

		var desc = DataStorage.inst.entityStorage.getDescriptionById( entityDescriptionId );
		var entityLocal = new OverworldEntity( desc, id );
		componentsRepl.followEntityClient( entityLocal );
		transformRepl.followEntityClient( entityLocal );

		entity.resolve( entityLocal );
	}

	function onEntityDisposed( ?v ) {
		trace( "entity net disposed" );

		unregister( NetworkHost.current );
		componentsRepl.dispose();
		parent?.removeChild( this );
	}

	function onLocationChanged( _, location : Location ) {
		locationDescId = location?.locationDesc.id.toString();
	}
}
