package net;

#if client
import util.Assert;
import en.Entity;
import util.Const;
import signals.Signal;
import dn.Process;
import game.client.GameClient;
import h2d.Flow;
import ui.MainMenu;
import ui.core.ShadowedText;
import ui.core.TextButton;
import ui.dialog.ConfirmDialog;
import util.Assets;
import util.Repeater;

@:build( util.Macros.buildNetworkMessageSignals( net.Message ) )
class Client extends Process {

	public static var inst : Client;

	static var CONNECT_REPEATER_ID : String = "connect";
	static var PORT = 6676;

	// temp
	static var infoFlow : Flow;

	public var host : hxd.net.SocketHost;

	public var onConnection : Signal = new Signal();
	public var onConnectionClosed : Signal = new Signal();

	public var connected( get, never ) : Bool;
	function get_connected() @:privateAccess return host.connected;

	var game : GameClient;

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
		connect();
		if ( !connected ) {
			addOnConnectionCallback(() -> {
				Main.inst.repeater.unset( '$CONNECT_REPEATER_ID' );
			} );

			Main.inst.repeater.setS( '$CONNECT_REPEATER_ID', interval, repeats, () -> {
				connect();
			} );
		}
	}

	public function connect( hostIp = "127.0.0.1", ?onFail : Void -> Void ) {
		Assert.isNull( host, "double host creation on client, unknown behaviour..." );

		host = new hxd.net.SocketHost();
		host.setLogger( function ( msg ) {
			#if network_debug
			log( msg );
			#end
		} );

		trace( "trying to connect" );

		host.connect( hostIp, PORT, function ( connectionStatus ) {
			if ( !connectionStatus ) {
				if ( !Main.inst.repeater.has( '$CONNECT_REPEATER_ID' ) ) {
					if ( infoFlow != null )
						infoFlow.remove();

					// server not found
					infoFlow = new Flow( Boot.inst.s2d );
					infoFlow.verticalAlign = Middle;
					var textInfo = new ShadowedText( Assets.fontPixel, infoFlow );
					textInfo.text = "unable to connect... ";

					var mainMenuBut : TextButton = null;
					mainMenuBut = new TextButton( "return back to menu", ( e ) -> {
						mainMenuBut.cursor = Default;
						infoFlow.remove();
						destroy();
						MainMenu.spawn( Boot.inst.s2d );
					}, infoFlow );
					infoFlow.getProperties( mainMenuBut ).verticalAlign = Bottom;

					trace( "Failed to connect to server" );
				}
				return;
			}
			if ( infoFlow != null )
				infoFlow.remove();

			trace( "Connected to server" );

			sendMessage( Message.ClientAuth );

			onConnection.dispatch();
		} );

		@:privateAccess
		host.socket.onError = onError;

		host.onMessage = onMessage;

		host.onUnregister = function ( o ) {
			if ( Std.isOfType( o, Entity ) ) cast( o, Entity ).destroy();
		};
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
		Main.inst.root.add(
			new ConfirmDialog(
				"Connection closed",
				( e ) -> MainMenu.spawn( Boot.inst.s2d )
			).h2dObject,
			Const.DP_UI
		);
		trace( "connection closed" );
		onConnectionClosed.dispatch();
	}

	override function update() {
		super.update();
		host?.flush();
	}

	public function sendMessage( msg : Message ) {
		host?.sendMessage( msg );
	}
}
#end
