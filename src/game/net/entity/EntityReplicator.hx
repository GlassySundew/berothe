package game.net.entity;

import game.net.entity.components.UnitPosReplicator;
import hxbit.NetworkHost;
import net.NetNode;

class EntityReplicator extends NetNode {

	@:s public var pos : UnitPosReplicator;

	public function new( ?parent ) {

		super( parent );

		
	}

	override public function unregister( host : NetworkHost, ?ctx ) {

		super.unregister( host, ctx );

		
	}

	public function followServer() {

		
	}

	#if client
	override function onUnregistered() {
		// trace( "entity disconnected " + entity.result );
		super.onUnregistered();
		// entity.result.dispose();
	}
	#end

	// function onEntityDisposed( ?v ) {
		
	// 	parent?.removeChild( this );
	// 	unregister( NetworkHost.current );
	// 	__host = null;
	// }

	override function alive() {
		super.alive();

		// reach out for client singleton container's world

		// var entityLocal = new OverworldEntity( desc, id );

		// EntityFactory.createAndAttachClientComponentsFromProperties( desc, entityLocal );
	}
	// @:keep
	// public function toString() : String {
	// 	return "EntityReplicator: " ;
	// }
}
