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
			instance.scaleX,
			instance.scaleY,
			instance.scaleZ,
			instance.rotationX,
			instance.rotationY,
			instance.rotationZ,
			instance.x,
			instance.y,
			instance.z,
			instance.name,
			cdbEntry.blockEntity,
			cdbEntry.spawnedEntity
		);
	}

	public final spawnedEntityDesc : EntityDescription;

	public function new(
		sizeX : Float,
		sizeY : Float,
		sizeZ : Float,
		rotationX : Float,
		rotationY : Float,
		rotationZ : Float,
		x : Float,
		y : Float,
		z : Float,
		name : String,
		blockEntityId : Data.EntityKind,
		spawnedEntityId : Data.EntityKind
	) {
		super(
			sizeX,
			sizeY,
			sizeZ,
			rotationX,
			rotationY,
			rotationZ,
			x,
			y,
			z,
			name,
			blockEntityId );
		spawnedEntityDesc = DataStorage.inst.entityStorage.getDescriptionById( spawnedEntityId.toString() );
	}
}
