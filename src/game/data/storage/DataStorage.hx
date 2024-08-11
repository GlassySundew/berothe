package game.data.storage;

import game.data.storage.entity.body.EntityPropertiesStorage;
import game.data.storage.entity.EntityDescriptionStorage;
import game.data.storage.entity.body.EntityPresetDescriptionStorage;
import game.data.storage.location.LocationDescriptionStorage;

class DataStorage {

	public static var inst( default, null ) : DataStorage;

	public final locationStorage : LocationDescriptionStorage = new LocationDescriptionStorage();
	public final entityPresetStorage : EntityPresetDescriptionStorage = new EntityPresetDescriptionStorage();
	public final entityStorage : EntityDescriptionStorage = new EntityDescriptionStorage();
	public final rule : RuleStorage;

	public final entityPropertiesStorage : EntityPropertiesStorage = new EntityPropertiesStorage();

	public function new() {
		inst = this;

		rule = new RuleStorage( Data.rule );

		locationStorage.init( Data.location );
		entityPresetStorage.init( Data.entityPreset );
		entityStorage.init( Data.entity );
	}
}
