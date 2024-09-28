package game.data.location.prefab;

import util.Const;
import game.data.storage.DataStorage;
import hrt.prefab.Prefab;
import hrt.prefab.l3d.Instance;
import hxd.res.Loader;
import util.HideUtil;
import game.domain.overworld.location.ILocationObjectsDataProvider;
import game.data.location.objects.LocationEntityVO;
import game.data.location.objects.LocationSpawnVO;
import game.data.storage.entity.EntityDescription;


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
		switch ( Type.getClass( localPrefab ) ) {
			case Instance: resolveInstance( Std.downcast( localPrefab, Instance ) );
			case e:
				trace( "object: " + e + " is not supported while parsing root location objects" );
		}
		return false;
	}

	function resolveInstance( instance : Instance ) {
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
				trace( "Prefab instance: " + e + " " + " sheet id: " + cdbSheetId + "; is not suppported" );
		}
	}

	function resolveContainer( prefab : Prefab ) : Array<LocationEntityVO> {
		var result = [];

		function parsePrefabElementsLocal( prefabLocal : Prefab ) : Bool {
			result.push( LocationObjectFactory.fromPrefab( prefabLocal ) );
			return false;
		}

		HideUtil.mapPrefabChildrenWithDerefRec( prefab, parsePrefabElementsLocal );

		return result;
	}
}
