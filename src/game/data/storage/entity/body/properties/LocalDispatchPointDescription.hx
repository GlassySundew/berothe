package game.data.storage.entity.body.properties;

import game.net.entity.EntityComponentReplicatorBase;
import net.NetNode;
import game.domain.overworld.entity.EntityComponent;
import game.data.storage.entity.component.EntityComponentDescription;
import game.domain.overworld.entity.component.EntityLocalPointComponent;

enum abstract LocalPointName( String ) {

	var FLOWER;

	public static function fromCdbEntry( entry : Data.EntityPropertySetup_properties_localDispatchPoint_name ) : LocalPointName {
		return switch entry {
			case Flower: FLOWER;
		}
	}
}

class LocalDispatchPointDescription extends EntityComponentDescription {

	public static function fromCdb(
		entry : Data.EntityPropertySetup_properties_localDispatchPoint
	) : LocalDispatchPointDescription {
		if ( entry == null ) return null;

		var name = LocalPointName.fromCdbEntry( entry.name );

		return new LocalDispatchPointDescription(
			name,
			entry.offsetX,
			entry.offsetY,
			entry.offsetZ,
			"localDispatch"
		);
	}

	public final name : LocalPointName;
	public final offsetX : Float;
	public final offsetY : Float;
	public final offsetZ : Float;

	public function new( name : LocalPointName, offsetX : Float, offsetY : Float, offsetZ : Float, id ) {
		super( id );
		this.name = name;
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.offsetZ = offsetZ;

		isReplicable = false;
	}

	public function buildComponent() : EntityComponent {
		return new EntityLocalPointComponent( this );
	}

	public function buildCompReplicator( ?parent : NetNode ) : EntityComponentReplicatorBase {
		throw new haxe.exceptions.NotImplementedException();
	}
}
