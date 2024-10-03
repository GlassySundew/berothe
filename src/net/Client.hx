package net;

import hxbit.NetworkSerializable;
import rx.disposables.ISubscription;
#if client
import util.Assert;
import util.Const;
import signals.Signal;
import dn.Process;
import game.net.client.GameClient;
import h2d.Flow;
import ui.MainMenu;
import ui.core.ShadowedText;
import ui.core.TextButton;
import ui.dialog.ConfirmDialog;
import util.Assets;
import util.Repeater;

@:build( util.Macros.buildNetworkMessageSignals( net.Message ) )
class Client extends Process {

	public static var inst( default, null ) : Client;
	static final PORT = 6676;

	public var host( default, null ) : hxd.net.SocketHost;

	public final onConnection : Signal = new Signal();
	public final onConnectionClosed : Signal = new Signal();
	public final onUnregister : Signal<NetworkSerializable> = new Signal<NetworkSerializable>();

	public var connected( get, never ) : Bool;
	function get_connected() @:privateAccess return host.connected;

	var game : GameClient;
	var connectionRepeater : ISubscription;

	public function new() {
		super( Main.inst );
		inst = this;

		Main.inst.onClose.add(() -> {
			try {
				sendMessage( Disconnect );
				host?.dispose();
			} catch( e : Dynamic ) {
				trace( "error occured while disposing client: " + e );
			}
		} );

		game = new GameClient();
	}

	public function repeatConnect( interval = 0.5, repeats = 6 ) {
		connect(() -> {
			connectionRepeater = Repeater.repeatSeconds(
				() -> connect(),
				1, 5,
				() -> trace( "client has failed to connect" )
			);
		} );
	}

	public function log( s : String, ?pos : haxe.PosInfos ) {
		pos.fileName = ( host.isAuth ? "[S]" : "[C]" ) + " " + pos.fileName;
		haxe.Log.trace( s, pos );
	}

	public function connect( hostIp = "127.0.0.1", ?onFail : Void -> Void ) {
		if ( hostIp == "" ) hostIp = "127.0.0.1";

		Assert.isNull( host, "double host creation on client, unknown behaviour..." );

		host = new hxd.net.SocketHost();
		host.setLogger( function ( msg ) {
			#if network_debug
			log( msg );
			#end
		} );

		host.onUnregister = onUnregister.dispatch;

		trace( "trying to connect" );

		host.connect(
			hostIp,
			PORT,
			function ( connectionStatus ) {
				if ( !connectionStatus ) {
					if ( onFail != null ) onFail();

					trace( "Failed to connect to server" );
					return;
				}

				sendMessage( Message.ClientAuth );

				onConnection.dispatch();
			}
		);

		@:privateAccess
		host.socket.onError = onError;

		host.onMessage = onMessage;
	}

	public function disconnect() {
		try {
			host.dispose();
		} catch( e ) {
			trace( e );
		}
	}

	public function addOnConnectionCallback( callback : Void -> Void ) {
		if ( connected )
			callback();
		else {
			onConnection.add( callback );
			onConnection.repeat( 1 );
		}
	}

	function onError( msg : String ) {
		switch msg {
			case "Connection closed" | "Failed to write data":
				if ( connected ) connectionClosed();
			default:
				connectionClosed();
		}
	}

	function connectionClosed() {
		disconnect();
		new ConfirmDialog(
			"Connection closed",
			( e ) -> {
				new MainMenu( Main.inst.root );
			},
			Main.inst.root
		);
		trace( "connection closed" );
		onConnectionClosed.dispatch();
	}

	override function postUpdate() {
		super.postUpdate();
		host?.flush();
	}

	public function sendMessage( msg : Message ) {
		host?.sendMessage( msg );
	}
}
#end
