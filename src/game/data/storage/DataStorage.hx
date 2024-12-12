package game.data.storage;

import game.data.storage.npcResponses.NpcResponseStorage;
import game.data.storage.faction.FactionDescriptionStorage;
import game.data.storage.item.ItemDescription;
import game.data.storage.entity.EntityDescriptionStorage;
import game.data.storage.item.ItemDescriptionStorage;
import game.data.storage.entity.body.EntityPresetDescriptionStorage;
import game.data.storage.location.LocationDescriptionStorage;

class DataStorage {

	public static var inst( default, null ) : DataStorage;

	public final locationStorage : LocationDescriptionStorage = new LocationDescriptionStorage();
	public final entityPresetStorage : EntityPresetDescriptionStorage = new EntityPresetDescriptionStorage();
	public final entityStorage : EntityDescriptionStorage = new EntityDescriptionStorage();
	public final factionStorage : FactionDescriptionStorage = new FactionDescriptionStorage();
	public final itemStorage : ItemDescriptionStorage = new ItemDescriptionStorage();
	public final npcResponsesStorage : NpcResponseStorage = new NpcResponseStorage();
	public final rule : RuleStorage;

	public function new() {
		inst = this;

		rule = new RuleStorage( Data.rule );

		locationStorage.init( Data.location );
		entityPresetStorage.init( Data.entityPreset );
		entityStorage.init( Data.entity );
		itemStorage.init( Data.item );
		factionStorage.init( Data.faction );
		npcResponsesStorage.init( Data.npcResponse );
	}
}
