package net;

#if client
import game.client.en.comp.EntityControl;
#end
import game.net.location.LocationReplicator;
import game.net.entity.EntityReplicator;
import game.net.client.GameClient;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable;
import util.Assert;
import util.Const;
import util.Settings;
import util.tools.Save;
import net.transaction.Transaction;

enum SaveSystemOrderType {
	CreateNewSave( name : String );
	// LoadGame( name : String );
	SaveGame( name : String );
	DeleteSave( name : String );
}

/**
	`ClientController` is a root net node for a singular player's channel
**/
class ClientController extends NetNode {

	public static var clientInst : ClientController;

	/** server-side **/
	public var networkClient( default, null ) : NetworkClient;

	public function new( networkClient : NetworkClient ) {
		super();
		this.networkClient = networkClient;
	}

	#if client
	override public function alive() {
		super.alive();

		if ( clientInst != null && Client.inst.host.isChannelingEnabled )
			throw "clientController instance is replicated on a client where it is not supposed to be";

		clientInst = this;

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

	public function unreg(
		host : NetworkHost,
		ctx : NetworkSerializer,
		?finalize
	) @:privateAccess {}

	@:rpc( owner )
	public function giveControlOverEntity( entityRepl : EntityReplicator ) {
		#if server
		trace( "bad rpc func call, should be on client only..." );
		#end

		#if client
		Assert.notNull( GameClient.inst, "Error: game client is null ( probably this code has been executed on server )" );

		entityRepl.entity.then( entity -> new EntityControl( entity, entityRepl ) );
		#end
	}

	@:rpc( owner )
	public function onControlledEntityLocationChange( locationRepl : LocationReplicator ) {
		#if client
		Assert.notNull( GameClient.inst, "Error: game client is null ( probably this code has been executed on server )" );

		GameClient.inst.onLocationProvided( locationRepl );
		#end
	}

	@:rpc( server )
	public function orderSaveSystem( type : SaveSystemOrderType ) : Bool {
		switch type {
			case CreateNewSave( name ):
				Save.inst.makeFreshSave( name );
			case SaveGame( name ):
				Save.inst.saveGame( name );
			case DeleteSave( name ):
				hxd.File.delete( Settings.inst.SAVEPATH + name + Const.SAVEFILE_EXT );
		}

		return true;
	}

	@:rpc( server )
	public function sendTransaction( t : Transaction ) : TransactionResult {
		return t.validate();
	}

	/**
		костыль для бага, нужен любой rpc вызов чтобы 
		подгрузить Level после подключения
	**/
	@:rpc
	function emptyPing() {}
}
