package game.data.storage;

import game.data.storage.entity.EntityDescriptionStorage;
import game.data.storage.entity.body.EntityBodyDescriptionStorage;
import game.data.storage.location.LocationDescriptionStorage;

class DataStorage {

	public static var inst( default, null ) : DataStorage;

	public final locationStorage : LocationDescriptionStorage = new LocationDescriptionStorage();
	public final entityBodyStorage : EntityBodyDescriptionStorage = new EntityBodyDescriptionStorage();
	public final entityStorage : EntityDescriptionStorage = new EntityDescriptionStorage();

	public function new() {
		inst = this;

		locationStorage.init( Data.location );
		entityBodyStorage.init( Data.entityBody );
		entityStorage.init( Data.entity );
	}
}
