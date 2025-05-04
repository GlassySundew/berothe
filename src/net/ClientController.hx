package net;

import signals.Signal;
#if server
import game.net.player.PlayerReplicationService;
#end
#if client
import game.client.en.comp.EntityControl;
#end
import game.net.client.GameClient;
import game.net.entity.EntityReplicator;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable;
import util.Assert;
import util.Repeater;
import net.transaction.Transaction;

enum InfoMessageType {
	SKILLS;
	TEXT( text : String );
}

/**
	`ClientController` is a root net node for a singular player's channel
**/
class ClientController extends NetNode {

	/** server-side **/
	#if server
	public var networkClient( default, null ) : NetworkClient;
	public var playerReplService( default, null ) : PlayerReplicationService;
	#end

	public var onInfoMessage( default, null ) = new Signal<InfoMessageType>();

	public function new( networkClient : NetworkClient ) {
		super();
		#if server
		this.networkClient = networkClient;
		#end

		// @:privateAccess
		// var test = IPFetcher.get_peer_name( Std.downcast( networkClient, SocketClient ).socket.s.handle );
		// trace(test.toBytes(22).toString());
	}

	@:rpc( server )
	public function executeCommand( command : InfoMessageType ) {
		
	}

	#if server
	public function providePlayerReplService( service : PlayerReplicationService ) {
		this.playerReplService = service;
	}
	#end

	#if client
	override public function alive() {
		super.alive();

		Client.inst.host.self.ownerObject = this;
		Main.inst.cliCon.val = this;
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

		entityRepl.entity.then(
			entity -> new EntityControl(
				entity,
				entityRepl,
				this
			) );
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

	@:rpc( owner )
	public function pingClient() : Bool {
		return true;
	}
}

class TestNetPinger extends NetNode {

	public function new( ?parent ) {
		super( parent );
		Repeater.repeatSeconds( testPing, 1 );
	}

	@:rpc
	public function testPing() {
		trace( "PIIIIIIINNNNNG" );
	}
}
