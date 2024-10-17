package game.data.location.prefab;

import hrt.prefab.Object3D;
import hrt.prefab.Prefab;
import hxd.res.Loader;
import util.Const;
import util.HideUtil;
import game.data.location.objects.LocationEntityVO;
import game.data.location.objects.LocationSpawnVO;
import game.data.storage.entity.EntityDescription;
import game.domain.overworld.location.ILocationObjectsDataProvider;

class LocationPrefabSource implements ILocationObjectsDataProvider {

	var spawns : Array<LocationSpawnVO> = [];
	var globalObjects : Array<LocationEntityVO> = [];
	var presentEntities : Array<LocationEntityVO> = [];

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

	public function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawnVO> {
		return spawns.filter( ( spawn : LocationSpawnVO ) -> {
			return spawn.spawnedEntityDesc == entityDesc;
		} );
	}

	public function getGlobalObjects() {
		return globalObjects;
	}

	public function getPresentEntities() : Array<LocationEntityVO> {
		return presentEntities;
	}

	function parse() {
		HideUtil.mapPrefabChildrenWithDerefRec( prefab, parsePrefabElement );
	}

	function parsePrefabElement( localPrefab : Prefab ) {
		if ( localPrefab is Object3D ) {
			if ( !localPrefab.editorOnly && localPrefab.enabled ) {
				resolveInstance( Std.downcast( localPrefab, Object3D ) );
			}
		} else {
			trace( "object: " + localPrefab + " is not supported while parsing root location objects" );
		}
		return false;
	}

	function resolveInstance( instance : Object3D ) {

		var cdbSheetId : DataSheetIdent = Std.string( Reflect.field( instance.props, Const.cdbTypeIdent ) );

		switch cdbSheetId {
			case ENTITY_SPAWNPOINT:
				var entry : Data.EntitySpawnPointDFDef = instance.props;
				spawns.push( LocationSpawnVO.fromPrefabInstance( instance, entry ) );
			case LOCATION_OBJ_CONTAINER_TYPE:
				var entry : Data.LocationObjContainerTypeDFDef = instance.props;
				switch entry.type {
					case global:
						globalObjects = globalObjects.concat( resolveContainer( instance ) );
				}
			case LOCATION_ENTITY_PRESENT:
				var entry : Data.LocationEntityDF = instance.props;
				presentEntities.push(
					LocationEntityVO.fromPrefabInstance( instance, entry )
				);
			case e:
				trace( instance.editorOnly, instance.enabled );
				trace( "Prefab instance: " + instance + " " + " sheet id: " + cdbSheetId + "; is not suppported" );
		}
	}

	function resolveContainer( prefab : Prefab ) : Array<LocationEntityVO> {
		var result = [];

		function parsePrefabElementsLocal( prefabLocal : Prefab ) : Bool {
			var obj3D = Std.downcast( prefabLocal, Object3D );
			if ( obj3D != null && obj3D.props != null )
				result.push( LocationObjectFactory.fromPrefab( obj3D ) );
			return true;
		}

		HideUtil.mapPrefabChildrenWithDerefRec( prefab, parsePrefabElementsLocal );

		return result;
	}
}
