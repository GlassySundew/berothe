package game.data.location.prefab;

import game.data.location.objects.LocationLinkObjectVO;
import game.data.location.objects.LocationEntityTriggerVO;
import hrt.prefab.Object3D;
import hrt.prefab.Prefab;
import hxd.res.Loader;
import util.Const;
import util.HideUtil;
import game.data.location.objects.LocationEntityVO;
import game.data.location.objects.LocationSpawnVO;
import game.data.location.objects.LocationObjectVO;
import game.data.storage.entity.EntityDescription;
import game.domain.overworld.location.ILocationObjectsDataProvider;

class LocationPrefabSource implements ILocationObjectsDataProvider {

	var spawns : Array<LocationSpawnVO> = [];
	var globalObjects : Array<LocationEntityVO> = [];
	var presentEntities : Array<LocationEntityVO> = [];
	var triggers : Array<LocationEntityTriggerVO> = [];
	var locationTransitionExits : Array<LocationLinkObjectVO> = [];

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

	#if !debug inline #end
	public function getSpawnPoints() : Array<LocationSpawnVO> {
		return spawns;
	}

	#if !debug inline #end
	public function getSpawnsByEntityDesc( entityDesc : EntityDescription ) : Array<LocationSpawnVO> {
		return spawns.filter( ( spawn : LocationSpawnVO ) -> {
			return spawn.spawnedEntityDesc == entityDesc;
		} );
	}

	public inline function getGlobalObjects() {
		return globalObjects;
	}

	public inline function getPresentEntities() : Array<LocationEntityVO> {
		return presentEntities;
	}

	public inline function getTriggers() : Array<LocationEntityTriggerVO> {
		return triggers;
	}

	public inline function getLocationTransitionExits() : Array<LocationLinkObjectVO> {
		return locationTransitionExits;
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
						globalObjects = globalObjects.concat(
							LocationObjectFactory.parseGlobalContainer( instance )
						);
					case entityCollisionTrigger:
						triggers.push( LocationEntityTriggerVO.fromPrefabInstance( instance, entry ) );
					case entityTransitionExit:
						locationTransitionExits.push(
							LocationLinkObjectVO.fromPrefabInstance( instance, entry )
						);
					case e: trace( "entity container type: " + e + " is not supported" );
				}
			case LOCATION_ENTITY_PRESENT:
				var entry : Data.LocationEntityDF = instance.props;
				presentEntities.push(
					LocationEntityVO.fromPrefabInstance( instance, entry )
				);
			case e:
				trace( "Prefab instance: " + instance + " " + " sheet id: " + cdbSheetId + "; is not suppported" );
		}
	}
}
