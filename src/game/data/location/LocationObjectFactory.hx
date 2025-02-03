package game.data.location;

import util.HideUtil;
import hrt.prefab.Prefab;
import util.Const;
import hrt.prefab.Object3D;
import plugins.prefab_berothe.src.customObj.CustomBox;
import game.data.location.objects.LocationEntityVO;

class LocationObjectFactory {

	public static function parseGlobalContainer( prefab : Prefab ) : Array<LocationEntityVO> {
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
										if (
											prefabChild != null
											// && !prefabChild.editorOnly
											// && prefabChild.enabled
										)
											result.push( LocationEntityVO.fromPrefabInstance(
												Std.downcast( prefabChild, Object3D ),
												entry.props.entity
											) );
										return true;
									}
								);
								return true;
							default:
						}
					default:
				}
				result.push( LocationObjectFactory.fromPrefab( obj3D ) );
			}
			return true;
		}

		HideUtil.mapPrefabChildrenWithDerefRec( prefab, parsePrefabElementsLocal );

		return result;
	}

	public static function fromPrefab( prefab : Object3D ) : LocationEntityVO {
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
						+ cdbSheetId + "; is not supported"
					);
			}
		}
		return null;
	}
}
