package game.data.storage;

import haxe.exceptions.PosException;
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

	public function getDescriptionByCdb( cdb : CdbType ) {
		return items[untyped cdb.id.toString()];
	}

	public function getDescriptionById( id : String ) : T {
		return items[id];
	}

	public function parseItem( entry : CdbType ) : Void {
		throw new PosException( "should be overriden" );
	}

	function addItem( item : T ) {
		Assert.isNull(
			items[item.id],
			'id collision in description storage: $this, item id: ${item.id}, for item: $item, current present: ${items[item.id]}'
		);
		items[item.id] = item;
	}
}
