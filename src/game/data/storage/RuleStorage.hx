package game.data.storage;

import cdb.Types.IndexId;

class RuleStorage {

	public var entityGravityScale( default, null ) : Float;

	public function new( rules : IndexId<Data.Rule, Data.RuleKind> ) {
		for ( entry in rules.all ) {
			var value = null;
			for ( field in Reflect.fields( entry.value ) ) {
				var fieldValue = Reflect.field( entry.value, field );
				if ( fieldValue != null ) {
					value = fieldValue;
					break;
				}
			}
			if ( value == null ) {
				trace( "value of rule id: " + entry.id + " is null!" );
				continue;
			}
			Reflect.setField( this, entry.id.toString(), value );
		}
	}
}
