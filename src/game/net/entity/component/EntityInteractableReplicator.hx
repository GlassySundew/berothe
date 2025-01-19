package game.net.entity.component;

import game.domain.overworld.entity.EntityComponent;
import rx.disposables.Composite;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.NSMutableProperty;
import core.MutableProperty;
import signals.Signal;
import future.Future;
import game.domain.overworld.entity.component.EntityDynamicsComponent;
import game.data.storage.DataStorage;
import util.MathUtil;
import dn.M;
#if client
import game.net.client.GameClient;
import ui.InteractorFactory;
import ui.tooltip.text.TextTooltipMediator;
import game.client.en.comp.view.EntityViewComponent;
import game.net.entity.EntityReplicator;
#end
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.component.EntityInteractableComponent;

class EntityInteractableReplicator extends EntityComponentReplicatorBase {

	var interactableComponent( get, never ) : EntityInteractableComponent;
	inline function get_interactableComponent() {
		return Std.downcast( component, EntityInteractableComponent );
	}

	@:s var isTurnedOn : NSMutableProperty<Bool> = new NSMutableProperty<Bool>( true );

	override public function networkAllow(
		op : hxbit.NetworkSerializable.Operation,
		propId : Int,
		clientSer : hxbit.NetworkSerializable
	) : Bool {
		return true;
	}

	override function followComponentServer( component : EntityComponent, entityRepl : EntityReplicator ) {
		super.followComponentServer( component, entityRepl );
		Std.downcast( component, EntityInteractableComponent ).isTurnedOn.subscribeProp( isTurnedOn );
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		isTurnedOn.unregister( host, ctx );
	}

	#if client
	override function followComponentClient( entity : EntityReplicator ) {
		super.followComponentClient( entityRepl );

		followedComponent.then( ( comp ) -> {
			Std.downcast( comp, EntityInteractableComponent )
				.interactive.then(
					( int ) -> int.onClick.add(
						( e ) -> useBy( GameClient.inst.controlledEntity.val )
					)
				);
		} );
	}
	#end

	@:rpc( server )
	function useBy( entityRepl : EntityReplicator ) : Void {
		interactableComponent.useBy( entityRepl.entity.result );
	}
}
