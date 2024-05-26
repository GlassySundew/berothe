#if server
package net;

import dn.Process;
import game.server.GameServer;
import hxbit.NetworkHost.NetworkClient;
import hxd.net.SocketHost;
import util.Env;
import util.Repeater;
import util.tools.Save;
import net.ClientController;

using util.Extensions.SocketHostExtender;

/**
	server-side
	network host setup
**/
class Server extends Process {

	public static var inst : Server;

	static var parsedPort = Std.parseInt( Sys.getEnv( "PORT" ) );
	static var PORT : Int = parsedPort != null ? parsedPort : 6676;
	static var HOST = "0.0.0.0";

	public var host( default, null ) : SocketHost;
	public var uid : Int;

	public var game : GameServer;

	public final repeater : Repeater = new Repeater( hxd.Timer.wantedFPS );

	public function new( ?seed : String ) {
		super();
		inst = this;

		Env.init();
		Save.initFields();

		#if( hl && pak )
		hxd.Res.initPak();
		#elseif( hl )
		hxd.Res.initLocal();
		#end

		new Save();

		if ( GameServer.inst != null ) {
			GameServer.inst.destroy();
			game = new GameServer( this );
		} else
			game = new GameServer( this );

		startServer();
	}

	/**
		added in favor of unserializing

		@param mockConstructor if true, then we will execute dn.Process constructor clause
	**/
	public function initLoad( ?mockConstructor = true ) {
		if ( mockConstructor ) {
			init();

			if ( parent == null )
				Process.ROOTS.push( this );
			else
				parent.addChild( this );
		}

		inst = this;
	}

	function startServer() {
		host = new hxd.net.SocketHost();
		host.setLogger( function ( msg ) {
			#if network_debug
			log( msg );
			#end
		} );

		try {
			@:privateAccess
			host.waitFixed( HOST, PORT,
				function ( c : NetworkClient ) {
					log( "Client Connected" );
				},
				function ( c : SocketClient, e : String ) {
					if ( c.host != null ) {
						destroyClient( c );
					}
				}
			);

			host.onMessage = onMessage;

			host.onUnregister = function ( c ) {
				log( 'unregistered ' + c );
			}

			log( "Server Started" );
			host.makeAlive();
		} catch( e : Dynamic ) {
			log( "port 6676 is already taken, server will not be booted..." );
		}
	}

	public function destroyClient( c : SocketClient ) {
		var clientController = cast( c.ownerObject, ClientController );
		if ( clientController.__host == null ) return;
		// if ( clientController.player != null ) clientController.player.destroy(); // TODO remove this into signals
		for ( i => client in host.clientsOwners ) {
			clientController.unreg( host, client.ctx, i + 1 == host.clients.length );
		}
	}

	public function log( s : String, ?pos : haxe.PosInfos ) {
		pos.fileName = ( host.isAuth ? "[S]" : "[C]" ) + " " + pos.fileName;
		haxe.Log.trace( s, pos );
	}

	override function update() {
		repeater.update( tmod );
	}

	override function postUpdate() {
		host.flush();
	}

	function onMessage( from : NetworkClient, msg : Dynamic ) {
		if ( game != null ) {
			trace( "got message " + msg );
			game.onMessage( from, msg );
		}
	}
}
#end
