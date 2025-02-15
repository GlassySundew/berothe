package game.client.en.comp.view.extensions;

import h3d.mat.Material;
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

			#if !debug inline #end
			function createStencil( ?mat : Material ) : Stencil {
				return switch desc.type {
					case Obstacle:
						var stencilPass = mat?.mainPass;
						var stencil = new Stencil();
						stencil.setFunc( Always, 1 );
						stencil.setOp( Keep, Keep, Replace );

						if ( mat != null ) mat.mainPass.depthTest = Less;
						if ( stencilPass != null ) stencilPass.stencil = stencil;

						stencil;
					case Objective:
						var stencilPass = mat?.allocPass( "stencil" );
						var stencil = new Stencil();
						stencilPass.depthTest = Greater;
						stencil.setFunc( LessEqual, 1, 0xFF, 0 );
						stencil.setOp( Keep, Keep, Replace );

						if ( stencilPass != null ) {
							stencilPass.stencil = stencil;
							stencilPass.enableLights = false;
							stencilPass.culling = Front;
							var colorSet = new FixedColor( 0x806c00 );
							colorSet.USE_ALPHA = false;

							stencilPass.addShader( colorSet );
							var props = new h3d.shader.pbr.PropsValues( 1, 1, 1, 1 );
							stencilPass.addShader( props );
						}

						stencil;
				}
			}

			if ( mats.length == 0 ) {
				var batch : BatchElement = obj.find( ( obj ) -> {
					return Std.downcast( obj, BatchElement );
				} );
				if ( batch != null ) createStencil( batch.batch.mb.material );
			}

			for ( mat in mats ) {
				if ( mat.mainPass.stencil != null ) continue;
				createStencil( mat );
			}
		} );
	}
}
