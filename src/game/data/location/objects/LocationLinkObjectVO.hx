package game.data.location.objects;

import hrt.prefab.Object3D;

class LocationLinkObjectVO extends LocationObjectVO {

	public static function fromPrefabInstance(
		instance : Object3D,
		cdbEntry : Data.LocationObjContainerTypeDFDef
	) : LocationLinkObjectVO {

		return new LocationLinkObjectVO(
			instance.scaleX,
			instance.scaleY,
			instance.scaleZ,
			instance.rotationX,
			instance.rotationY,
			instance.rotationZ,
			instance.x,
			instance.y,
			instance.z,
			cdbEntry.props.location.toString(),
			instance.name
		);
	}

	public final locationDescId : String;

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
		locationDescId : String,
		name : String
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
		this.locationDescId = locationDescId;
	}
}
