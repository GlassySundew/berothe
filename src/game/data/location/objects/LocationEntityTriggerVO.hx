package game.data.location.objects;

import util.Assert;
import hrt.prefab.Object3D;

class LocationEntityTriggerVO extends LocationObjectVO {
	
	public static function fromPrefabInstance(
		instance : Object3D,
		cdbEntry : Data.LocationObjContainerTypeDFDef
	) : LocationEntityTriggerVO {

		return new LocationEntityTriggerVO(
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
			cdbEntry.extra,
			instance
		);
	}

	public final prefab : Object3D;
	public final triggerId : String;

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
		triggerId : String,
		prefab : Object3D
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

		this.triggerId = triggerId;
		this.prefab = prefab;
	}
}