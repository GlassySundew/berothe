package net;

import hxd.net.SocketHost.SocketClient;
import hxd.net.Socket;
import game.net.server.GameServer;
import util.Repeater;
#if client
import game.client.en.comp.EntityControl;
#end
import game.net.entity.EntityReplicator;
import game.net.client.GameClient;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable;
import util.Assert;
import util.Const;
import util.Settings;
import util.tools.Save;
import net.transaction.Transaction;

/**
	`ClientController` is a root net node for a singular player's channel
**/
class ClientController extends NetNode {

	/** server-side **/
	public var networkClient( default, null ) : NetworkClient;

	public function new( networkClient : NetworkClient ) {
		super();
		this.networkClient = networkClient;

		// @:privateAccess
		// var test = IPFetcher.get_peer_name( Std.downcast( networkClient, SocketClient ).socket.s.handle );
		// trace(test.toBytes(22).toString());
	}

	#if client
	override public function alive() {
		super.alive();

		Client.inst.host.self.ownerObject = this;
		Main.inst.cliCon.val = this;

		#if( debug && client )
		new game.debug.ImGuiGameClientDebug( GameClient.inst );
		#end
	}
	#end

	public override function networkAllow(
		op : hxbit.NetworkSerializable.Operation,
		propId : Int,
		clientSer : hxbit.NetworkSerializable
	) : Bool {
		return clientSer == this;
	}

	@:rpc( owner )
	public function giveControlOverEntity( entityRepl : EntityReplicator ) {
		#if server
		trace( "bad rpc func call, should be on client only..." );
		#end

		#if client
		Assert.notNull( GameClient.inst, "Error: game client is null ( probably this code has been executed on server )" );

		entityRepl.entity.then( entity -> new EntityControl( entity, entityRepl ) );
		GameClient.inst.controlledEntity.val = entityRepl;
		#end
	}

	@:rpc( owner )
	public function onControlledEntityLocationChange( locationDescId : String ) {
		#if client
		Assert.notNull( GameClient.inst, "Error: game client is null ( probably this code has been executed on server )" );

		GameClient.inst.onLocationProvided( locationDescId );
		#end
	}

	@:rpc( server )
	public function sendTransaction( t : Transaction ) : TransactionResult {
		return t.validate();
	}

	/**
		костыль для бага, нужен любой rpc вызов чтобы 
		подгрузить Level после подключения
	**/
	// @:rpc
	// function emptyPing() {}
}

class TestNetPinger extends NetNode {

	public function new( ?parent ) {
		super( parent );
		Repeater.repeatSeconds( testPing, 1 );
	}

	@:rpc
	public function testPing() {
		trace( "PPPIIIIIIINNNNNG" );
	}
}
