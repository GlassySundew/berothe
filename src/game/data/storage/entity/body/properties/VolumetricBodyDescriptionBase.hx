package game.data.storage.entity.body.properties;

import game.data.storage.entity.component.EntityComponentDescription;

abstract class VolumetricBodyDescriptionBase extends EntityComponentDescription {

	public final offsetZ : Int = 0;
	public final sizeX : Int = 0;
	public final sizeY : Int = 0;
	public final sizeZ : Int = 0;

	public function new( offsetZ : Int, sizeX : Int, sizeY : Int, sizeZ : Int ) {
		this.offsetZ = offsetZ;
		this.sizeX = sizeX;
		this.sizeY = sizeY;
		this.sizeZ = sizeZ;
	}
}
