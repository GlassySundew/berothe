package game.data.storage.location;

import game.domain.overworld.location.ILocationObjectsDataProvider;
import game.data.location.prefab.LocationDataResolver;

enum LocationType {
	Prefab( file : String );
}

class LocationDescription extends DescriptionBase {

	#if !debug inline #end
	public static function fromCdb( entry : Data.Location ) : LocationDescription {
		var locType : LocationType = //
			switch entry.level {
				case Prefab( file ):
					LocationType.Prefab( file.file );
			}

		return new LocationDescription(
			locType,
			entry.chunkSize,
			entry.isOpen,
			entry.id.toString()
		);
	}

	public final chunkSize : Int;
	public final isOpenAir : Bool;

	final levelType : LocationType;

	public function new(
		locType : LocationType,
		chunkSize : Int,
		isOpenAir : Bool,
		id : String
	) {
		super( id );
		this.levelType = locType;
		this.chunkSize = chunkSize;
		this.isOpenAir = isOpenAir;
	}

	public function createLocationDataResolver() : LocationDataResolver {
		return new LocationDataResolver( levelType );
	}
}
