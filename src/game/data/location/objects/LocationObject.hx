package game.data.location.objects;

abstract class LocationObject {

	public final x : Float;
	public final y : Float;
	public final z : Float;
	public final name : String;

	public function new(
		x : Float,
		y : Float,
		z : Float,
		name : String
	) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.name = name;
	}
}
