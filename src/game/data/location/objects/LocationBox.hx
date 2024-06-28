package game.data.location.objects;

class LocationBox extends LocationObject {

	public final sizeX : Float;
	public final sizeY : Float;
	public final sizeZ : Float;
	public final rotationX : Float;
	public final rotationY : Float;
	public final rotationZ : Float;

	public function new( sizeX, sizeY, sizeZ, rotationX, rotationY, rotationZ, x, y, z, name ) {
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
		this.rotationX = rotationX;
		this.rotationY = rotationY;
		this.rotationZ = rotationZ;

		super( x, y, z, name );
	}
}
