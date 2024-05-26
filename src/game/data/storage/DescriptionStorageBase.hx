package game.data.storage;

import game.data.storage.DescriptionBase;
import haxe.exceptions.NotImplementedException;
import cdb.Types.IndexId;

abstract class DescriptionStorageBase<T : DescriptionBase, CdbType> {

	var items : Map<String, T> = new Map<String, T>();

	public function new() {}

	public function init( data : IndexId<CdbType, Any> ) {
		for ( entry in data.all ) {
			parseItem( entry );
		}
	}

	public function getDescriptionById( id : String ) : T {
		return items[id];
	}

	abstract function parseItem( entry : CdbType ) : Void;

	function addItem( item : T ) {
		items[item.id] = item;
	}
}
