package game.data.location.objects;

import hrt.prefab.Object3D;
import dn.M;
import hrt.prefab.l3d.Instance;
import util.Assert;
import game.data.storage.DataStorage;
import game.data.storage.entity.EntityDescription;

class LocationEntityVO extends LocationObjectVO {

	public static function fromPrefabInstance(
		instance : Object3D,
		cdbEntry : Data.LocationEntityDF
	) : LocationEntityVO {

		return new LocationEntityVO(
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
			instance,
			cdbEntry.entity.id
		);
	}

	public final entityDesc : EntityDescription;
	public final prefab : Object3D;

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
		prefab : Object3D,
		entityCdb : Data.EntityKind
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

		this.prefab = prefab;
		entityDesc = DataStorage.inst.entityStorage.getDescriptionById( entityCdb.toString() );

		Assert.notNull( entityDesc, "entity block description: " + entityCdb + " is null" );
	}
}
