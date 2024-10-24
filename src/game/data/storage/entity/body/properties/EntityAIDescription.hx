package game.data.storage.entity.body.properties;

import game.domain.overworld.entity.component.ai.EntityAIComponent;
import game.net.entity.EntityComponentReplicatorBase;
import game.domain.overworld.entity.EntityComponent;
import net.NetNode;
import game.data.storage.entity.component.EntityComponentDescription;

inline function getTypeFromCdb( cdbEntry : Data.NpcBehaviour ) : EntityBehaviourType {
	return
		switch cdbEntry.id {
			case sleepyPointGuard: SLEEPY_POINT_GUARD;
		}
}

enum abstract EntityBehaviourType( String ) to String {

	var SLEEPY_POINT_GUARD;
}

class EntityAIDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb(
		entry : Data.EntityProperty_properties_behaviour
	) : Null<EntityAIDescription> {

		if ( entry == null ) return null;
		return new EntityAIDescription(
			getTypeFromCdb( entry.type ),
			[for ( param in entry.params ) param.param]
		);
	}

	public final type : EntityBehaviourType;
	public final params : Array<String>;

	public function new(
		id : EntityBehaviourType,
		params : Array<String>
	) {
		super( id );
		type = id;
		this.params = params;
		replicable = false;
	}

	public function buildComponent() : EntityComponent {
		return new EntityAIComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
