package game.data.location.prefab;

import hrt.prefab.Prefab;
import hrt.prefab.l3d.Instance;
import hxd.res.Loader;
import util.HideUtil;
import game.core.rules.overworld.location.ILocationObjectsDataProvider;
import game.data.location.objects.LocationObject;
import game.data.location.objects.LocationSpawn;
import game.data.storage.entity.EntityDescription;

enum abstract DataSheetIdent( String ) from String {

	var ENTITY_SPAWNPOINT = "entitySpawnPointDF";
	var LOCATION_OBJ_CONTAINER_TYPE = "locationObjContainerTypeDF";
}

class LocationPrefabSource implements ILocationObjectsDataProvider {

	var spawns : Array<LocationSpawn> = [];
	var globalObjects : Array<LocationObject> = [];

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

	public function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawn> {
		return spawns.filter( ( spawn:LocationSpawn ) -> {
			return spawn.spawnedEntityDesc == entityDesc;
		} );
	}

	public function getGlobalObjects() {
		return globalObjects;
	}

	function parse() {
		HideUtil.mapPrefabChildrenWithDerefRec( prefab, parsePrefabElement );
	}

	function parsePrefabElement( localPrefab : Prefab ) {
		switch ( Type.getClass( localPrefab ) ) {
			case Instance: resolveInstance( Std.downcast( localPrefab, Instance ) );
			case e:
				trace( "object: " + e + " is not supported while parsing root location objects" );
		}
		return false;
	}

	function resolveInstance( instance : Instance ) {
		var cdbSheetId : DataSheetIdent = Std.string( Reflect.field( instance.props, "$cdbtype" ) );

		switch cdbSheetId {
			case ENTITY_SPAWNPOINT:
				var entry : Data.EntitySpawnPointDFDef = instance.props;
				spawns.push( LocationSpawn.fromPrefabInstance( instance, entry ) );
			case LOCATION_OBJ_CONTAINER_TYPE:
				var entry : Data.LocationObjContainerTypeDFDef = instance.props;
				switch entry.type {
					case global:
						globalObjects = globalObjects.concat( resolveContainer( instance ) );
				}
			case e:
				trace( "Prefab instance: " + e + " " + " sheet id: " + cdbSheetId + "; is not suppported" );
		}
	}

	function resolveContainer( prefab : Prefab ) : Array<LocationObject> {
		var result = [];

		function parsePrefabElementsLocal( prefabLocal : Prefab ) : Bool {
			result.push( LocationObjectFactory.fromPrefab( prefabLocal ) );
			return false;
		}

		HideUtil.mapPrefabChildrenWithDerefRec( prefab, parsePrefabElementsLocal );

		return result;
	}
}
