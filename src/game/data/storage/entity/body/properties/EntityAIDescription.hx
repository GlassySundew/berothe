package game.data.storage.entity.body.properties;

import game.domain.overworld.entity.component.ai.EntityAIComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import net.NetNode;
import game.data.storage.entity.component.EntityComponentDescription;

class AIProperties {

	public final triggerId : Null<String>;
	public final agroRange : Null<Float>;

	public inline function new( entry : Data.EntityPropertySetup_properties_behaviour_params ) {
		triggerId = entry.triggerId;
		agroRange = entry.agroRange;
	}
}

inline function getTypeFromCdb( cdbEntry : Data.NpcBehaviour ) : EntityBehaviourType {
	return
		switch cdbEntry.id {
			case flowerPollinator: FLOWER_POLLINATOR;
			case sleepyPointGuard: SLEEPY_POINT_GUARD;
			case randomRoaming: RANDOM_ROAMING;
		}
}

enum abstract EntityBehaviourType( String ) to String {

	var FLOWER_POLLINATOR;
	var SLEEPY_POINT_GUARD;
	var RANDOM_ROAMING;
}

class EntityAIDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb(
		entry : Data.EntityPropertySetup_properties_behaviour
	) : Null<EntityAIDescription> {

		if ( entry == null ) return null;
		return new EntityAIDescription(
			getTypeFromCdb( entry.type ),
			entry.params != null ? new AIProperties( entry.params ) : null
		);
	}

	public final type : EntityBehaviourType;
	public final params : AIProperties;

	public function new(
		id : EntityBehaviourType,
		params : AIProperties
	) {
		super( id );
		type = id;
		this.params = params;
		isReplicable = false;
	}

	public function buildComponent() : EntityComponent {
		return new EntityAIComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
