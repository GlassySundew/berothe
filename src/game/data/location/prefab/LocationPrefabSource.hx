package game.data.location.prefab;

import hrt.prefab.l2d.Text;
import game.data.storage.entity.EntityDescription;
import game.data.location.objects.LocationSpawnDescription;
import plugins.prefab_berothe.src.customObj.CustomBox;
import plugins.prefab_berothe.src.customObj.Collision;
import hrt.prefab.l3d.Instance;
import util.HideUtil;
import hrt.prefab.Prefab;
import hxd.res.Loader;
import game.core.rules.overworld.location.ILocationObjectsDataProvider;

enum abstract DataSheetIdent( String ) from String {

	var ENTITY_SPAWNPOINT = "entitySpawnPointDF";
}

class LocationPrefabSource implements ILocationObjectsDataProvider {

	var spawns : Array<LocationSpawnDescription> = [];

	var file : String;
	var prefab : Prefab;

	public function new( file : String ) {
		this.file = file;
	}

	public function load() {
		if ( prefab != null ) return;
		// TODO maybe multithread this
		prefab = Loader.currentInstance.load( file ).toPrefab().load();

		parse();
	}

	public function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawnDescription> {
		return spawns.filter( ( spawn ) -> {
			return spawn.entityDesc == entityDesc;
		} );
	}

	function parse() {
		HideUtil.mapPrefabWithDeref( prefab, parsePrefabElement );
	}

	function parsePrefabElement( localPrefab : Prefab ) {
		trace( "parsing: " + localPrefab.name );
		switch ( Type.getClass( localPrefab ) ) {
			case Instance: resolveInstance( Std.downcast( localPrefab, Instance ) );
			case Collision:
			case CustomBox:
			case Text:
			case e:
				trace( "found not suppported item: " + e + " while parsing prefab: " + prefab.shared.prefabSource );
		}
	}

	function resolveInstance( instance : Instance ) {
		var cdbSheetId : DataSheetIdent = Std.string( Reflect.field( instance.props, "$cdbtype" ) );

		return
			switch cdbSheetId {
				case ENTITY_SPAWNPOINT:
					var entry : Data.EntitySpawnPointDFDef = instance.props;
					spawns.push( LocationSpawnDescription.fromPrefabInstance( instance, entry ) );
				case e:
					throw "Prefab instance: " + e + " is not suppported";
			}
	}
}
