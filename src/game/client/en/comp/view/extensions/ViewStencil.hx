package game.client.en.comp.view.extensions;

import h3d.mat.Texture;
import h3d.shader.FixedColor;
import graphics.BatchElement;
import h3d.mat.Stencil;
import game.data.storage.entity.body.view.extensions.ViewStencilDescription;
import game.data.storage.entity.body.view.extensions.ViewColorRandomShiftDescription;

class ViewStencil extends EntityViewExtensionComponentBase {

	public var desc( get, never ) : ViewStencilDescription;
	function get_desc() : ViewStencilDescription {
		return Std.downcast( description, ViewStencilDescription );
	}

	public function new( desc : ViewStencilDescription ) {
		super( desc );
	}

	override function onViewCompAppeared() {
		super.onViewCompAppeared();
		viewComp.view.then( ( view ) -> {
			var obj = view.getGraphics().heapsObject;
			var mats = obj.getMaterials();

			if ( mats.length == 0 ) {
				var batches : Array<BatchElement> = obj.findAll( ( obj ) -> {
					return Std.downcast( obj, BatchElement );
				} );
				for ( batch in batches ) {
					mats.push( batch.batch.mb.material );
				}
			}

			for ( mat in mats ) {

				switch desc.type {
					case Obstacle:
						var stencilPass = mat.mainPass;
						var stencil = stencilPass.stencil = new Stencil();
						stencil.setFunc( Always, 1 );
						stencil.setOp( Keep, Keep, Replace );
						mat.mainPass.depthTest = Less;
					case Objective:
						var stencilPass = mat.allocPass( "stencil" );
						var stencil = stencilPass.stencil = new Stencil();
						stencilPass.depthTest = Greater;
						stencil.setFunc( Equal, 1, 0xFF, 0 );
						stencil.setOp( Keep, Keep, Replace );
						stencilPass.enableLights = false;
						stencilPass.culling = Front;
						var colorSet = new FixedColor( 0x806c00 );
						colorSet.USE_ALPHA = false;

						stencilPass.addShader( colorSet );
						var props  = new h3d.shader.pbr.PropsValues( 0, 1, 0, 1 );
						stencilPass.addShader( props );
				}
			}
		} );
	}
}
