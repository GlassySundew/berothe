package game.data.storage.location;

import game.domain.overworld.location.ILocationObjectsDataProvider;
import game.data.location.prefab.LocationDataResolver;

enum LocationInstancingType {
	PerPlayer;
	PerRealm;
	Singleton;
}

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

		var instancing : LocationInstancingType = {
			switch entry.instancing {
				case PerPlayer: PerPlayer;
				case PerRealm: PerRealm;
				case Singleton: Singleton;
			}
		}

		return new LocationDescription(
			locType,
			entry.chunkSize,
			entry.isOpen,
			instancing,
			entry.id.toString()
		);
	}

	public final chunkSize : Int;
	public final isOpenAir : Bool;
	public final instancing : LocationInstancingType;

	final levelData : LocationType;

	var dataResolver : LocationDataResolver;

	public function new(
		levelData : LocationType,
		chunkSize : Int,
		isOpenAir : Bool,
		instancing : LocationInstancingType,
		id : String
	) {
		super( id );
		this.levelData = levelData;
		this.chunkSize = chunkSize;
		this.isOpenAir = isOpenAir;
		this.instancing = instancing;
	}

	public function getDataResolver() : LocationDataResolver {
		return( dataResolver ?? ( dataResolver = new LocationDataResolver( levelData ) ) );
	}
}
