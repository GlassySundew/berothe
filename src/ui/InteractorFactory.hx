package ui;

import ui.tooltip.TooltipManager;
import shader.OutlineExtruder;
import h3d.shader.FixedColor;
import dn.Col;
import h3d.scene.Mesh;
import h3d.col.Collider;
import h2d.domkit.Object;
import graphics.ThreeDObjectNode;
import graphics.ThrEventInteractive;
import ui.tooltip.TooltipBaseVO;

class InteractorVO {

	public var doHighlight : Bool = false;
	public var highlightColor : Int;
	public var tooltipVO : TooltipBaseVO;
	public var handCursor : Bool = true;

	public function new() {}
}

class InteractorFactory {

	public static function create(
		interactorVO : InteractorVO,
		graphics : ThreeDObjectNode
	) {
		var meshes = graphics.heapsObject.getMeshes();
		var collider = new GroupCollider( [
			for ( mesh in meshes ) mesh.getCollider()
		] );
		var int = ThrEventInteractive.fromHeaps( new h3d.scene.Interactive( collider ) );
		graphics.addChild( int );

		var materials = graphics.heapsObject.getMaterials();
		for ( material in materials ) {
			var m = material;
			var p = m.allocPass( "highlight" );
			p.culling = None;
			p.depthWrite = false;
			p.depthTest = LessEqual;
		}
		var shader = new FixedColor( interactorVO.highlightColor );
		int.onOver.add( ( e ) -> {
			for ( m in materials ) {
				var pass = m.getPass( "highlight" );
				pass.culling = None;
				pass.addShader( shader );
			}
		} );
		function removeHighlight() {
			for ( m in materials ) {
				var pass = m.getPass( "highlight" );
				pass.culling = Both;
				pass.removeShader( shader );
			}
		}
		removeHighlight();
		int.onOut.add( ( e ) -> removeHighlight() );

		TooltipManager.attach3d( interactorVO.tooltipVO, int );
	}
}
