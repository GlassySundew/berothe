package game.data.location.prefab;

import sys.thread.Thread;
import hxd.impl.AsyncLoader.ThreadAsyncLoader;
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

	public function load( onComplete : Void -> Void ) {
		if ( prefab != null ) return;

		Thread.create(() -> {
			prefab = Loader.currentInstance.load( file ).toPrefab().load();
			parse();
			onComplete();
		} );
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
		if ( Std.isOfType( localPrefab, Object3D ) ) {
			if ( !localPrefab.editorOnly && localPrefab.enabled ) {
				resolveInstance( Std.downcast( localPrefab, Object3D ) );
			}
		} else {
			trace( 'ignoring object $localPrefab in level root' );
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
					case Global:
						globalObjects = globalObjects.concat(
							parseGlobalContainer( instance )
						);
					case EntityCollisionTrigger:
						triggers.push( LocationEntityTriggerVO.fromPrefabInstance( instance, entry ) );
					case EntityTransitionExit:
						locationTransitionExits.push(
							LocationLinkObjectVO.fromPrefabInstance( instance, entry )
						);
					case e: trace( "entity container type: " + e + " is not supported" );
				}
			case LOCATION_ENTITY_PRESENT:
				var entry : Data.LocationEntityDF = instance.props;
				presentEntities.push(
					LocationEntityVO.fromPrefabInstance( instance, entry.entity )
				);
			case e:
				trace( "Prefab instance: " + instance + " " + " sheet id: " + cdbSheetId + "; is not suppported" );
		}
	}

	function parseGlobalContainer( prefab : Prefab ) : Array<LocationEntityVO> {
		var result = [];

		function parsePrefabElementsLocal( prefabLocal : Prefab ) : Bool {
			if ( prefabLocal == null || prefabLocal.editorOnly ) return false;

			var obj3D = Std.downcast( prefabLocal, Object3D );
			if ( obj3D != null && obj3D.props != null ) {
				var cdbSheetId : DataSheetIdent = Std.string( Reflect.field( prefabLocal.props, Const.cdbTypeIdent ) );
				switch cdbSheetId {
					case LOCATION_OBJ_CONTAINER_TYPE:
						var entry : Data.LocationObjContainerTypeDF = prefabLocal.props;
						switch entry.type {
							case EntityInstancedRenderGroup:
								var elements = parseGlobalContainer( prefabLocal );
								for ( ele in elements ) {
									ele.isBatched = true;
									result.push( ele );
								}
								return false;
							case PropagatedEntityType:
								HideUtil.mapPrefabChildrenWithDerefRec(
									prefabLocal,
									( prefabChild ) -> {
										if ( prefabChild != null // && !prefabChild.editorOnly
											// && prefabChild.enabled
										)
											result.push(
												LocationEntityVO.fromPrefabInstance(
													Std.downcast( prefabChild, Object3D ),
													entry.props.entity
												)
											);
										return true;
									}
								);
								return true;
							default:
						}
					default:
				}
				result.push( fromPrefab( obj3D ) );
			}
			return true;
		}

		HideUtil.mapPrefabChildrenWithDerefRec( prefab, parsePrefabElementsLocal, false );

		return result;
	}

	function fromPrefab( prefab : Object3D ) : LocationEntityVO {
		if ( prefab.props != null ) {
			var cdbSheetId : DataSheetIdent = Std.string( Reflect.field( prefab.props, Const.cdbTypeIdent ) );
			switch cdbSheetId {
				case LOCATION_ENTITY_PRESENT:
					var entry : Data.LocationEntityDF = cast prefab.props;
					return LocationEntityVO.fromPrefabInstance( prefab, entry.entity );
				case LOCATION_OBJ_CONTAINER_TYPE:
					var entry : Data.LocationObjContainerTypeDF = prefab.props;
					switch entry.type {
						case EntityInstancedRenderGroup:
							// for ( child in prefab.children ) {
							// 	var childEntry : Data.LocationEntityDF = cast child.props;
							// 	if ( childEntry == null ) continue;
							// 	var vo = LocationEntityVO.fromPrefabInstance(
							// 		Std.downcast( child, Object3D ),
							// 		childEntry
							// 	);
							// 	vo.isBatched = true;
							// 	return vo;
							// }
						case e: trace( "global entity container type: " + e + " is not supported, name: " + prefab.name );
					}
				case e:
					trace(
						"static location object instance : "
						+ e + " " + " sheet id: "
						+ cdbSheetId + "; is not supported "
						+ prefab
					);
			}
		}
		return null;
	}
}
