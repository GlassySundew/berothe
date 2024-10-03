package game.data.storage;

import cdb.Types.IndexId;

class RuleStorage {

	public var entityGravityScale( default, null ) : Float;
	public var pickupRange( default, null ) : Float;
	public var playerStartLocation( default, null ) : String;

	public function new( rules : IndexId<Data.Rule, Data.RuleKind> ) {
		for ( entry in Reflect.fields( this ) ) {
			var rule = rules.resolve( entry );
			var value = null;
			// take first property from cdb set and set it to field
			for ( field in Reflect.fields( rule.value ) ) {
				var fieldValue = Reflect.field( rule.value, field );
				if ( fieldValue != null ) {
					value = fieldValue;
					break;
				}
			}

			if ( value == null ) {
				trace( "value of rule id: " + rule.id + " is null!" );
				continue;
			}
			Reflect.setField( this, rule.id.toString(), value );
		}
	}
}
