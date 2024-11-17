package game.client.en.comp.view;

import hxbit.Serializable;

enum MessageType {
	SPEECH;
	DAMAGE_TAKEN;
}

class EntityMessageVO implements Serializable {

	public static function speech( message : String ) : EntityMessageVO {
		return new EntityMessageVO( message, SPEECH );
	}

	public static function damageTaken( message : String ) : EntityMessageVO {
		return new EntityMessageVO( message, DAMAGE_TAKEN );
	}

	@:s public var type( default, null ) : MessageType;
	@:s public var message( default, null ) : String;

	public function new( message : String, type : MessageType ) {
		this.message = message;
		this.type = type;
	}
}
