package game.data.storage.entity.body.properties;



class HitboxBodyDescription extends VolumetricBodyDescriptionBase {

	public static function fromCdb(
		entry : Data.EntityPropertySetup_properties_bodyHitbox
	) : HitboxBodyDescription {
		if ( entry == null ) return null;
		return new HitboxBodyDescription(
			entry.offsetX,
			entry.offsetY,
			entry.offsetZ,
			entry.sizeX,
			entry.sizeY,
			entry.sizeZ,
			entry.id.toString()
		);
	}

}
