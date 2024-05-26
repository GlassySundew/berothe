package game.data.location.objects;

import hrt.prefab.l3d.Instance;
import game.data.storage.DataStorage;
import game.data.storage.entity.EntityDescription;

class LocationSpawnDescription {

	public static function fromPrefabInstance(
		instance : Instance,
		cdbEntry : Data.EntitySpawnPointDFDef
	) : LocationSpawnDescription {

		return new LocationSpawnDescription(
			Std.int( instance.x ),
			Std.int( instance.y ),
			Std.int( instance.z ),
			instance.name,
			DataStorage.inst.entityStorage.getDescriptionById( cdbEntry.entity.toString() )
		);
	}

	public final x : Int;
	public final y : Int;
	public final z : Int;
	public final name : String;
	public final entityDesc : EntityDescription;

	public function new(
		x : Int,
		y : Int,
		z : Int,
		name : String,
		desc : EntityDescription
	) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.name = name;
		entityDesc = desc;
	}
}
