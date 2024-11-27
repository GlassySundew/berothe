package game.net.entity.component;

import game.net.client.GameClient;
import game.client.en.comp.view.EntityMessageVO;
import game.client.en.comp.view.EntityViewComponent;
import game.domain.overworld.entity.component.combat.EntityDamageType;
import net.NSMutableProperty;
import core.MutableProperty;
import game.data.storage.DataStorage;
import net.NSArray;
import game.net.entity.component.model.EntityStatsReplicator;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import game.net.entity.component.model.EntityInventoryReplicator;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import game.net.entity.component.model.EntityEquipReplicator;
import game.domain.overworld.entity.EntityComponent;

class EntityModelComponentReplicator extends EntityComponentReplicatorBase {

	@:s public final displayName : NSMutableProperty<String> = new NSMutableProperty<String>();
	@:s final factionsRepl : NSArray<String> = new NSArray();
	@:s final isSleeping : NSMutableProperty<Bool> = new NSMutableProperty<Bool>();
	@:s final hp : NSMutableProperty<Int> = new NSMutableProperty<Int>();
	@:s var statsRepl : EntityStatsReplicator;
	@:s var equipRepl : EntityEquipReplicator;
	@:s var inventoryRepl : EntityInventoryReplicator;
	@:s var statusMessages : NSArray<EntityMessageVO> = new NSArray();

	public var modelComp( get, never ) : EntityModelComponent;
	inline function get_modelComp() return Std.downcast( component, EntityModelComponent );

	override function followComponentServer( component : EntityComponent, entityRepl ) {
		super.followComponentServer( component, entityRepl );

		statsRepl = new EntityStatsReplicator( modelComp.stats, entityRepl, this );
		equipRepl = new EntityEquipReplicator( modelComp.inventory, entityRepl, this );
		inventoryRepl = new EntityInventoryReplicator( modelComp.inventory, this );
		modelComp.factions.subscribe( ( i, val ) -> {
			if ( val != null ) factionsRepl[i] = val.id;
			else factionsRepl.removeByIdx( i );
		} );
		modelComp.isSleeping.subscribeProp( isSleeping );
		modelComp.displayName.subscribeProp( displayName );
		modelComp.onDamaged.add( onDamaged );
		modelComp.statusMessages.subscribeNetwork( statusMessages );
		modelComp.hp.subscribeProp( hp );

		if ( entityRepl.entity.result.desc.id == "player" )
			displayName.addOnValueImmediately( ( oldName, newName ) -> {
				if ( newName != null )
					trace( "player nameset: " + newName );
			} );
	}

	#if client
	override function followComponentClient( entityRepl : EntityReplicator ) {
		super.followComponentClient( entityRepl );

		followedComponent.then( ( comp ) -> {
			var modelComp : EntityModelComponent = Std.downcast( comp, EntityModelComponent );
			equipRepl.followClient( modelComp.inventory, entityRepl );
			inventoryRepl.followClient( modelComp.inventory );
			factionsRepl.subscribleWithMapping(
				( i, faction ) -> {
					modelComp.factions.set( i, DataStorage.inst.factionStorage.getById( faction ) );
				},
				( i, faction ) -> {
					trace( "removing faction" );
					modelComp.factions.removeByIdx( i );
				}
			);
			isSleeping.subscribeProp( modelComp.isSleeping );
			displayName.subscribeProp( modelComp.displayName );
			hp.subscribeProp( modelComp.hp );

			// todo this is temporary, remove after
			modelComp.displayName.subscribeProp( displayName );

			statusMessages.subscribleWithMapping(
				( i, elem ) -> modelComp.statusMessages.set( i, elem ),
				( i, elem ) -> modelComp.statusMessages.removeByIdx( i )
			);
		} );
	}
	#end

	public function setFriendly() {
		#if client
		var unfriendlyFactionMaybe = modelComp.factions.filter(
			( faction ) -> faction.id == DataStorage.inst.rule.unfriendlyPlayerFaction
		)[0];

		if ( unfriendlyFactionMaybe == null ) {
			GameClient.inst.consoleSay(
				Data.locale.get( Data.LocaleKind.no_more_friendliness ).text
			);
			return;
		}

		setFriendlyRPC();
		#end
	}

	public function setUnfriendly() {
		#if client
		var unfriendlyFactionMaybe = modelComp.factions.filter(
			( faction ) -> faction.id == DataStorage.inst.rule.unfriendlyPlayerFaction
		)[0];

		if ( unfriendlyFactionMaybe != null ) {
			GameClient.inst.consoleSay(
				Data.locale.get( Data.LocaleKind.no_more_violence ).text
			);
			return;
		}

		setUnfriendlyRPC();
		#end
	}

	@:rpc( server )
	public function sayText( text : String ) {
		modelComp.sayText( text );
	}

	@:rpc( clients )
	function onDamaged( amount : Float, type : EntityDamageType ) {}

	@:rpc( server )
	function setFriendlyRPC() {
		var unfrFactionId = DataStorage.inst.rule.unfriendlyPlayerFaction;
		var unfriendlyFactionMaybe = modelComp.factions.filter(
			( faction ) -> faction.id == unfrFactionId
		)[0];
		if ( unfriendlyFactionMaybe == null ) return;

		modelComp.factions.remove(
			DataStorage.inst.factionStorage.getById( unfrFactionId )
		);
	}

	@:rpc( server )
	function setUnfriendlyRPC() {
		var unfrFactionId = DataStorage.inst.rule.unfriendlyPlayerFaction;
		var unfriendlyFactionMaybe = modelComp.factions.filter(
			( faction ) -> faction.id == unfrFactionId
		)[0];
		if ( unfriendlyFactionMaybe != null ) return;

		modelComp.factions.push(
			DataStorage.inst.factionStorage.getById( unfrFactionId )
		);
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		displayName.unregister( host, ctx );
		factionsRepl.unregister( host, ctx );
		isSleeping.unregister( host, ctx );
		statsRepl.unregister( host, ctx );
		equipRepl.unregister( host, ctx );
		inventoryRepl.unregister( host, ctx );
		statusMessages.unregister( host, ctx );
	}

	override public function networkAllow(
		op : hxbit.NetworkSerializable.Operation,
		propId : Int,
		clientSer : hxbit.NetworkSerializable
	) : Bool {
		return true;
	}
}
