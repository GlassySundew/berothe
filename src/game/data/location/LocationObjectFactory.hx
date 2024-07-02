package game.data.location;

import hrt.prefab.Object3D;
import plugins.prefab_berothe.src.customObj.CustomBox;
import game.data.location.objects.LocationObject;

enum abstract StaticObjectDFIdent( String ) from String {

	var LOCATION_STATIC_OBJ_DF = "locationStaticObjDF";
}

class LocationObjectFactory {

	public static function fromPrefab( prefab : hrt.prefab.Prefab ) : LocationObject {
		if ( prefab.props != null ) {
			var cdbSheetId : StaticObjectDFIdent = Std.string( Reflect.field( prefab.props, "$cdbtype" ) );
			switch cdbSheetId {
				case LOCATION_STATIC_OBJ_DF:
					var entry : Data.LocationStaticObjDFDef = cast prefab.props;
					var box = Std.downcast( prefab, Object3D );
					return new LocationObject(
						box.scaleX,
						box.scaleY,
						box.scaleZ,
						box.rotationX,
						box.rotationY,
						box.rotationZ,
						box.x,
						box.y,
						box.z,
						prefab.name,
						entry.blockEntity
					);
				case e:
					trace( "static location object instance : " + e + " " + " sheet id: " + cdbSheetId + "; is not suppported" );
			}
		}
		return null;
	}
}
