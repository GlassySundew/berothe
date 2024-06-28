package game.data.location.objects;

import hrt.prefab.l3d.Instance;
import game.data.storage.DataStorage;
import game.data.storage.entity.EntityDescription;

class LocationSpawn extends LocationObject {

	public static function fromPrefabInstance(
		instance : Instance,
		cdbEntry : Data.EntitySpawnPointDFDef
	) : LocationSpawn {

		return new LocationSpawn(
			Std.int( instance.x ),
			Std.int( instance.y ),
			Std.int( instance.z ),
			instance.name,
			DataStorage.inst.entityStorage.getDescriptionById( cdbEntry.entity.toString() )
		);
	}

	public final entityDesc : EntityDescription;

	public function new(
		x : Int,
		y : Int,
		z : Int,
		name : String,
		desc : EntityDescription
	) {
		super( x, y, z, name );
		entityDesc = desc;
	}
}
