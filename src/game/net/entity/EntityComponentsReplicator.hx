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

	@:s public final components : NSClassMap<
		Class<EntityComponentReplicatorBase>,
		EntityComponentReplicatorBase
	> = new NSClassMap();

	var entityRepl : EntityReplicator;
	var isMappingFinished = false;

	public function followEntityServer( entityRepl : EntityReplicator ) {
		Assert.isNull( this.entityRepl, "double entity following for single replicator of components" );

		this.entityRepl = entityRepl;

		// entityRepl.entity.result.components.container.stream.observe( onComponentAdded );
	}

	public function followEntityClient( entity : EntityReplicator ) {
		components.subscribleWithMapping( ( classType, component ) -> {
			Assert.notNull( component );
			component.followComponentClient( entity );
		} );
	}

	public function dispose() {
		for ( component in components.keyValueIterator() ) {
			component.value.dispose();
		}
		components.__host = null;
	}

	function onComponentAdded( component : EntityComponent ) {
		if ( !component.description.isReplicable ) return;

		var replicator = component.description.buildCompReplicator( this );
		replicator.followComponentServer( component, entityRepl );

		Assert.isFalse( components.exists( untyped replicator.classType.__clid ) );

		components[replicator.classType] = replicator;
	}

	override function unregister( host : NetworkHost, ?ctx : NetworkSerializer ) {
		super.unregister( host, ctx );
		components.unregister( host, ctx );
	}
}
