package game.data.location;

import hrt.prefab.Object3D;
import game.data.location.objects.LocationBox;
import plugins.prefab_berothe.src.customObj.CustomBox;
import game.data.location.objects.LocationObject;

class LocationObjectFactory {

	public static function fromPrefab( prefab : hrt.prefab.Prefab ) : LocationObject {
		trace( prefab );
		return switch ( Type.getClass( prefab ) ) {
			case CustomBox:
				var box = Std.downcast( prefab, Object3D );
				return new LocationBox(
					box.scaleX,
					box.scaleY,
					box.scaleZ,
					box.rotationX,
					box.rotationY,
					box.rotationZ,
					box.x,
					box.y,
					box.z,
					prefab.name
				);
			case e:
				trace( "Prefab instance: " + e + " is not suppported in location desc factory" );
				return null;
		}
	}
}
