package game.data.storage.entity.body.properties;

import game.domain.overworld.entity.component.model.stat.EntityDefenceStat;
import game.net.entity.EntityComponentReplicatorBase;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.domain.overworld.entity.component.EntityFlyComponent;

class EntityFlyDescription extends EntityComponentDescription {

	#if !debug inline #end
	public static function fromCdb( entry : Data.EntityPropertySetup_properties_flying ) : EntityFlyDescription {
		if ( entry == null ) return null;
		return new EntityFlyDescription(
			entry.baseDistance,
			entry.amplitude,
			entry.frequency
		);
	}

	public final distance : Float;
	public final amplitude : Float;
	public final frequency : Float;

	public function new(
		distance : Float,
		amplitude : Float,
		frequency : Float
	) {
		super( "flying_comp" );
		isReplicable = false;
		
		this.distance = distance;
		this.amplitude = amplitude;
		this.frequency = frequency;
	}

	public function buildComponent() : EntityComponent {
		return new EntityFlyComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
