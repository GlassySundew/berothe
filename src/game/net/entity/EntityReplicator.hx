package game.net.entity;

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

	override function onUnregisteredClient() {
		super.onUnregisteredClient();
		entity.result.dispose();
	}

	@:rpc( clients )
	function test() {
		trace( entity.result, __host );
	}

	override function alive() {
		super.alive();

		var desc = DataStorage.inst.entityStorage.getDescriptionById( entityDescriptionId );
		var entityLocal = new OverworldEntity( desc, "0" ); // todo client ids
		componentsRepl.followEntityClient( entityLocal );
		transformRepl.followEntityClient( entityLocal );

		trace( "replicating new entity: " + desc );
		entity.resolve( entityLocal );
	}

	override public function unregister( host : NetworkHost, ?ctx ) {
		super.unregister( host, ctx );
	}

	function onLocationChanged( _, location : Location ) {
		locationDescId = location?.locationDesc.id.toString();
	}
}
