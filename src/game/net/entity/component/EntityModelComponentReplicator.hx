package game.net.entity.component;

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
		modelComp.factions.subscribe( ( i, val ) -> if ( val != null ) factionsRepl[i] = val.id );
		modelComp.isSleeping.subscribeProp( isSleeping );
		modelComp.displayName.subscribeProp( displayName );
		modelComp.onDamaged.add( onDamaged );
		modelComp.statusMessages.subscribeNetwork( statusMessages );
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
				}
			);
			isSleeping.subscribeProp( modelComp.isSleeping );
			displayName.subscribeProp( modelComp.displayName );

			// todo this is temporary, remove after
			modelComp.displayName.subscribeProp( displayName );

			statusMessages.subscribleWithMapping(
				( i, elem ) -> modelComp.statusMessages.set( i, elem ),
				( i, elem ) -> modelComp.statusMessages.removeByIdx( i )
			);

			entityRepl.entity.result.components.onAppear(
				EntityViewComponent,
				( cl, viewComp ) -> {
					viewComp.statusBarFuture.then( ( statusBar ) ->
						modelComp.statusMessages.onChanged.add( statusBar.setChatMessage )
					);
				}
			);
		} );
	}
	#end

	@:rpc( server )
	public function sayText( text : String ) {
		modelComp.sayText( text );
	}

	@:rpc( clients )
	function onDamaged( amount : Float, type : EntityDamageType ) {}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		equipRepl.unregister( host, ctx );
		inventoryRepl.unregister( host, ctx );
		factionsRepl.unregister( host, ctx );
	}

	override public function networkAllow(
		op : hxbit.NetworkSerializable.Operation,
		propId : Int,
		clientSer : hxbit.NetworkSerializable
	) : Bool {
		return true;
	}
}
