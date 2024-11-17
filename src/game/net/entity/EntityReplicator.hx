package game.net.entity;

import game.domain.overworld.entity.EntityFactory;
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

		componentsRepl = new EntityComponentsReplicator( this );

		entity.location.addOnValueImmediately( onLocationChanged );

		entity.postDisposed.then( onEntityDisposed );
	}

	override public function unregister( host : NetworkHost, ?ctx ) {
		trace( "unregistering " + entity.result );
		super.unregister( host, ctx );
		transformRepl.unregister( host, ctx );
		componentsRepl.unregister( host, ctx );
	}

	public function followServer() {
		componentsRepl.followEntityServer( this );
		transformRepl.followEntityServer( entity.result );
	}

	#if client
	override function onUnregisteredClient() {
		trace( "entity disconnected " + entity.result );
		super.onUnregisteredClient();
		entity.result.dispose();
	}
	#end

	function onEntityDisposed( ?v ) {
		trace( "removing entity" );
		componentsRepl.dispose();
		parent?.removeChild( this );
		unregister( NetworkHost.current );
		__host = null;
	}

	override function alive() {
		super.alive();

		var desc = DataStorage.inst.entityStorage.getById( entityDescriptionId );
		var entityLocal = new OverworldEntity( desc, id );

		EntityFactory.createAndAttachClientComponentsFromProperties( desc, entityLocal );

		componentsRepl.followEntityClient( this );
		transformRepl.followEntityClient( entityLocal );

		entity.resolve( entityLocal );

		trace( "aliving entity : " + this );
	}

	function onLocationChanged( _, location : Location ) {
		locationDescId = location?.locationDesc.id.toString();
	}

	@:keep
	public function toString() : String {
		return "EntityReplicator: " + entity?.result;
	}
}
