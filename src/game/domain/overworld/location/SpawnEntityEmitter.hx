package game.domain.overworld.location;

import game.data.location.objects.LocationSpawnVO;

class SpawnEntityEmitter {

	static final DELAYER_ID = "spawn_cd";

	final spawnVO : LocationSpawnVO;
	var location( default, null ) : Location;

	var entityCounter = 0;

	public function new( spawnVO : LocationSpawnVO ) {
		this.spawnVO = spawnVO;
	}

	public function attachToLocation( location : Location ) {
		this.location = location;

		spawnEntity();
	}

	function spawnEntity( ignoreDelayerPresence = false ) {
		var entity = GameCore.inst.entityFactory.createEntity( spawnVO.spawnedEntityDesc );
		entity.transform.setPosition(
			spawnVO.x,
			spawnVO.y,
			spawnVO.z
		);
		location.addEntity( entity );
		entityCounter++;
		onEntityAmountChanged( ignoreDelayerPresence );
		entity.postDisposed.then( _ -> {
			entityCounter--;
			onEntityAmountChanged();
		} );
	}

	function onEntityAmountChanged( ignoreDelayerPresence = false ) {
		trace( "current bees: " + entityCounter, entityCounter == spawnVO.maxEntitiesPresent, location.delayer.hasId( DELAYER_ID ) );
		if ( entityCounter == spawnVO.maxEntitiesPresent ) return;
		if (
			!ignoreDelayerPresence
			&& location.delayer.hasId( DELAYER_ID ) ) return;

		trace( "created entity spawn delayer" );

		location.delayer.addS(
			DELAYER_ID,
			spawnEntity.bind( true ),
			spawnVO.cooldown
		);
	}
}
