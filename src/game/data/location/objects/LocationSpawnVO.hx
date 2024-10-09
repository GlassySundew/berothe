package game.data.location.objects;

import hrt.prefab.Object3D;
import game.data.storage.DataStorage;
import game.data.storage.entity.EntityDescription;

class LocationSpawnVO extends LocationObjectVO {

	public static function fromPrefabInstance(
		instance : Object3D,
		cdbEntry : Data.EntitySpawnPointDFDef
	) : LocationSpawnVO {

		return new LocationSpawnVO(
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
			name
		);
		spawnedEntityDesc = DataStorage.inst.entityStorage.getDescriptionById( spawnedEntityId.toString() );
	}
}
