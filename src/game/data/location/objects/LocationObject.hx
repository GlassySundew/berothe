package game.data.location.objects;

import util.Assert;
import game.data.storage.DataStorage;
import game.data.storage.entity.EntityDescription;

class LocationObject {

	public final entityDesc : EntityDescription;

	public final sizeX : Float;
	public final sizeY : Float;
	public final sizeZ : Float;
	public final rotationX : Float;
	public final rotationY : Float;
	public final rotationZ : Float;
	public final x : Float;
	public final y : Float;
	public final z : Float;
	public final name : String;

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
		entityCdb : Data.EntityKind
	) {
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
		this.rotationX = rotationX;
		this.rotationY = rotationY;
		this.rotationZ = rotationZ;
		this.x = x;
		this.y = y;
		this.z = z;
		this.name = name;
		entityDesc = DataStorage.inst.entityStorage.getDescriptionById( entityCdb.toString() );

		Assert.notNull( entityDesc, "entity block description is null" );
	}
}
