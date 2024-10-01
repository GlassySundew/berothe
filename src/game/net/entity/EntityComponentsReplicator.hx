package game.net.entity;

import hxbit.NetworkHost;
import hxbit.NetworkSerializable.NetworkSerializer;
import net.NSArray;
import util.Assert;
import net.NSClassMap;
import net.NetNode;
import game.domain.overworld.entity.OverworldEntity;
import game.domain.overworld.entity.EntityComponent;
import game.net.entity.EntityComponentReplicatorBase;

/**
	`EntityComponentsReplicator` подключает реплицированные 
	"чистые" компоненты(`EntityComponent`),
	на клиенте, когда они приходят: функция `followEntityClient()`
**/
class EntityComponentsReplicator extends NetNode {

	@:s public var components : NSClassMap<
		Class<EntityComponentReplicatorBase>,
		EntityComponentReplicatorBase> = new NSClassMap();

	var entityRepl : EntityReplicator;
	var isMappingFinished = false;

	public function new( ?parent ) {
		super( parent );
	}

	public function followEntityServer( entityRepl : EntityReplicator ) {
		Assert.isNull( this.entityRepl, "double entity following for single replicator of components" );

		this.entityRepl = entityRepl;

		entityRepl.entity.result.components.map( onComponentAdded );
		isMappingFinished = true;
		entityRepl.entity.result.components.onComponentAdded.add( onComponentAdded );
	}

	public function followEntityClient( entity : EntityReplicator ) {
		components.subscribleWithMapping( ( classType, component ) -> {
			Assert.notNull( component );
			component.followComponentClient( entity );
		} );
	}

	public function dispose() {
		@:privateAccess
		for ( key => component in components.map ) {
			component.dispose();
		}
	}

	function onComponentAdded( component : EntityComponent ) {
		var replicator = component.description.buildCompReplicator( this );
		replicator?.followComponentServer( component, entityRepl );
		if ( replicator != null ) components[replicator.classType] = replicator;

		if (
			isMappingFinished
			&& entityRepl.entity.result.components.get( component.classType ) != null
		)
			trace( "apparently bad logic, double component set: " + component.classType );

		if ( replicator == null )
			trace( component + " component does not have network replication" );
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		components.unregister( host, ctx );
	}
}
