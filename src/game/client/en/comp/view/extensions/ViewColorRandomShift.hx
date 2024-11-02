package game.client.en.comp.view.extensions;

import format.hl.Tools;
import seedyrng.Random;
import h3d.Matrix;
import h3d.shader.ColorAdd;
import h3d.shader.ColorMatrix;
import game.data.storage.entity.body.view.extensions.ViewColorRandomShiftDescription;

class ViewColorRandomShift extends EntityViewExtensionComponentBase {

	public var desc( get, never ) : ViewColorRandomShiftDescription;
	function get_desc() : ViewColorRandomShiftDescription {
		return Std.downcast( description, ViewColorRandomShiftDescription );
	}

	public function new( desc : ViewColorRandomShiftDescription ) {
		super( desc );
	}

	override function onViewCompAppeared() {
		super.onViewCompAppeared();
		viewComp.view.then( ( view ) -> {
			var shader = new ColorAdd();
			var rand = new Random( Tools.hash( entity.id ) );
			var displace = rand.randomInt(-desc.radius, desc.radius ) / 255;
			shader.color.x = displace;
			shader.color.y = displace;
			shader.color.z = displace;
			for ( mat in view.getGraphics().heapsObject.getMaterials() ) {
				mat.mainPass.addShader( shader );
			}
		} );
	}
}
