package game.net.entity.component;

class EntityDynamicsComponentReplicator extends EntityComponentReplicator {

	public function new( ?parent ) {
		super( parent );
	}

	override function alive() {
		super.alive();
		trace( "aliving dynamics component" );
	}
}
