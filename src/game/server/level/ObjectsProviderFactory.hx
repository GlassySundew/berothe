package game.server.level;

class ObjectsProviderFactory {

	public static function create( conf : Data.Location ) : ILevelObjectsProvider {
		return null;
		// switch conf.level {
		// 	case Prefab( file ):
		// 		return new PrefabObjectsProvider( file.file );
		// }
	}
}
