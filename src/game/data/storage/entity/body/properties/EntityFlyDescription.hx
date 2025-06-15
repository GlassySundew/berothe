package game.data.storage.entity.body.properties;

import game.data.storage.entity.component.EntityComponentDescription;

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
}
