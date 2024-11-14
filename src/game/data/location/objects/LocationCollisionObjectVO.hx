package game.data.location.objects;

import game.data.storage.entity.EntityDescription;
import hrt.prefab.Object3D;

enum CollisionGeometryType {
	BOX;
}

class LocationCollisionObjectVO extends LocationObjectVO {

	public static function fromPrefabInstance(
		instance : Object3D,
		cdbEntry : Data.PLSTSpecialType
	) : LocationCollisionObjectVO {

		var geometry = switch cdbEntry {
			case CollisionBox: BOX;
			case e: throw e + " type is not supported for collision object type";
		}

		return new LocationCollisionObjectVO(
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
			geometry
		);
	}

	public final geometry : CollisionGeometryType;

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
		geom : CollisionGeometryType
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

		this.geometry = geom;
	}
}
