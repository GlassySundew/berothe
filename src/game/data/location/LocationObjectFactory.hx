package game.data.location;

import util.Const;
import hrt.prefab.Object3D;
import plugins.prefab_berothe.src.customObj.CustomBox;
import game.data.location.objects.LocationEntityVO;

class LocationObjectFactory {

	public static function fromPrefab( prefab : Object3D ) : LocationEntityVO {
		if ( prefab.props != null ) {
			var cdbSheetId : DataSheetIdent = Std.string( Reflect.field( prefab.props, Const.cdbTypeIdent ) );
			switch cdbSheetId {
				case LOCATION_ENTITY_PRESENT:
					var entry : Data.LocationEntityDF = cast prefab.props;
					return LocationEntityVO.fromPrefabInstance( prefab, entry );
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
