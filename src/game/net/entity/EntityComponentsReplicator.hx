package game.net.entity;

import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.NSArray;
import util.Assert;
import net.NSClassMap;
import net.NetNode;
import game.core.rules.overworld.entity.OverworldEntity;
import game.core.rules.overworld.entity.EntityComponent;
import game.net.entity.EntityComponentReplicator;

/**
	`EntityComponentsReplicator` подключает реплицированные 
	"чистые" компоненты(`EntityComponent`),
	на клиенте, когда они приходят: функция `followEntityClient()`
**/
class EntityComponentsReplicator extends NetNode {

	@:s public final components : NSArray<EntityComponentReplicator> = new NSArray();

	var entity : OverworldEntity;
	var isMappingFinished = false;

	public function new( ?parent ) {
		super( parent );
	}

	public function followEntityServer( entity : OverworldEntity ) {
		Assert.isNull( this.entity, "double entity following for entity comps replicator" );

		this.entity = entity;
		entity.components.map( onComponentAdded );
		isMappingFinished = true;
		entity.components.onComponentAdded.add( onComponentAdded );
	}

	public function followEntityClient( entity : OverworldEntity ) {
		components.subscribleWithMapping( ( component ) -> {
			Assert.notNull( component );
			component.followComponentClient( entity );
		} );
	}

	function onComponentAdded( component : EntityComponent ) {
		var replicator = component.description.buildCompReplicator( this );
		replicator?.followComponentServer( component );
		if ( replicator != null ) components.push( replicator );

		if (
			isMappingFinished
			&& entity.components.get( component.classType ) != null
		)
			trace( "apparently bad logic, double component set: " + component.classType );

		if ( replicator == null ) trace( component + " component does not have network replication" );
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer, finalize : Bool = false ) {
		// if(finalize) components.push
		super.unregister( host, ctx, finalize );
	}
}
