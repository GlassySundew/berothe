package game.data.storage;

import util.Assert;
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

	public function parseItem( entry : CdbType ) : Void {}

	function addItem( item : T ) {
		Assert.isNull( items[item.id], 'overlapping id set: ${item.id}, $item');
		items[item.id] = item;
	}
}
