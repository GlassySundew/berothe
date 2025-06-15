package game.data.storage.entity.component;



abstract class EntityComponentDescription extends DescriptionBase {

	public var isReplicable( default, null ) = true;

	// abstract public function buildComponent() : EntityComponent;
	// abstract public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase;
}
