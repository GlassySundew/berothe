package game.data.storage.entity.body.properties;

import game.data.storage.entity.component.EntityComponentDescription;

abstract class VolumetricBodyDescriptionBase extends EntityComponentDescription {

	public final offsetX : Float = 0;
	public final offsetY : Float = 0;
	public final offsetZ : Float = 0;
	public final sizeX : Float = 0;
	public final sizeY : Float = 0;
	public final sizeZ : Float = 0;

	public function new(
		offsetX : Float,
		offsetY : Float,
		offsetZ : Float,
		sizeX : Float,
		sizeY : Float,
		sizeZ : Float,
		id : String
	) {
		super( id );
		this.offsetX = offsetX;
		this.offsetY = offsetY;
		this.offsetZ = offsetZ;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
	}
}
