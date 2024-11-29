package game.data.location.objects;

import game.domain.overworld.location.SpawnEntityEmitter;
import hrt.prefab.Object3D;
import game.data.storage.DataStorage;
import game.data.storage.entity.EntityDescription;

class LocationSpawnVO extends LocationObjectVO {

	public static function fromPrefabInstance(
		instance : Object3D,
		cdbEntry : Data.EntitySpawnPointDFDef
	) : LocationSpawnVO {

		var cooldown = 0.;
		var maxEntitiesPresent = 0;
		if ( cdbEntry.emitter != null ) {
			cooldown = cdbEntry.emitter.cooldown;
			maxEntitiesPresent = cdbEntry.emitter.maxEntitiesPresent;
		}

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
			cooldown,
			maxEntitiesPresent,
			cdbEntry.spawnedEntity
		);
	}

	public final spawnedEntityDesc : EntityDescription;
	public final cooldown : Float;
	public final maxEntitiesPresent : Int;

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
		cooldown : Float,
		maxEntitiesPresent : Int,
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
		this.cooldown = cooldown;
		this.maxEntitiesPresent = maxEntitiesPresent;
		spawnedEntityDesc = DataStorage.inst.entityStorage.getById( spawnedEntityId.toString() );
	}

	public function createSpawnEmitter() : Null<SpawnEntityEmitter> {
		if ( maxEntitiesPresent == 0 ) return null;
		else return new SpawnEntityEmitter( this );
	}
}
