package game.net.entity;

import game.core.rules.overworld.location.Location;
import game.data.storage.DataStorage;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;

class EntityReplicator extends NetNode {

	public var entity( default, null ) : OverworldEntity;

	@:s var componentsRepl : EntityComponentsReplicator;
	@:s var entityDescriptionId : String;
	@:s var locationDescId : String;
	@:s var transformRepl : EntityTransformReplicator;

	public function new( entity : OverworldEntity, ?parent ) {
		super( parent );
		this.entity = entity;
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
		entity = new OverworldEntity( desc, "0" ); // todo client ids
		componentsRepl.followEntityClient( entity );
		transformRepl.followEntityClient( entity );
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer, finalize : Bool = false ) {
		if ( finalize ) componentsRepl = null;

		super.unregister( host, ctx, finalize );
	}

	function onLocationChanged( location : Location ) {
		locationDescId = location?.locationDesc.id.toString();
	}
}
