package net;

import game.net.location.LocationReplicator;
import game.net.entity.EntityReplicator;
import en.comp.client.EntityCameraFollowComponent;
import en.comp.client.EntityMovementControlComponent;
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

	override public function alive() {
		super.alive();

		if ( clientInst != null && Client.inst.host.isChannelingEnabled )
			throw "clientController instance is replicated on a client where it is not supposed to be";

		clientInst = this;

		Client.inst.host.self.ownerObject = this;
		Main.inst.cliCon.val = this;

		#if debug
		new game.debug.ImGuiGameClientDebug( GameClient.inst );
		#end
	}

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
		Assert.notNull( GameClient.inst, "Error: game client is null ( probably this code has been executed on server )" );

		// entity.onSpawned.handle(
		// 	( level ) -> {
		// 		entity.clientComponents.add(
		// 			new EntityMovementControlComponent( entity )
		// 		);
		// 		entity.clientComponents.add(
		// 			new EntityCameraFollowComponent( entity )
		// 		);
		// 	}
		// );
	}

	@:rpc( owner )
	public function onControlledEntityLocationChange( locationRepl : LocationReplicator ) {
		Assert.notNull( GameClient.inst, "Error: game client is null ( probably this code has been executed on server )" );

		GameClient.inst.onLocationProvided( locationRepl );
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
