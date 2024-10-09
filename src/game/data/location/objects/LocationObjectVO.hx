package game.data.location.objects;

import dn.M;

class LocationObjectVO {

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
		name : String
	) {
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
		this.rotationX = M.toRad( rotationX );
		this.rotationY = M.toRad( rotationY );
		this.rotationZ = M.toRad( rotationZ );
		this.x = x;
		this.y = y;
		this.z = z;
		this.name = name;
	}
}
