package ui;

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

		// ( function createhighlight() {
		// 	if ( !interactorVO.doHighlight ) return;

		// var shader = new h3d.shader.Outline();
		// shader.color = new Col( interactorVO.highlightColor ).toShaderVec4().toVector4();
		// shader.distance = 20;
		var materials = graphics.heapsObject.getMaterials();

		for ( m in materials ) {
			m.removePass( m.getPass( "highlight" ) );
			m.removePass( m.getPass( "highlightBack" ) );
		}

		var shader = new FixedColor( 0xF2F2F2 );

		int.onOver.add( ( e ) -> {
			for ( material in materials ) {
				var m = material;

				var p = m.allocPass( "highlight" );
				p.culling = None;
				p.depthWrite = false;
				p.depthTest = LessEqual;
				p.addShader(shader);
			}
		} );

		int.onOut.add( ( e ) -> {
			for ( m in materials ) {
				m.removePass( m.getPass( "highlight" ) );
				m.removePass( m.getPass( "highlightBack" ) );
			}
		} );
		// } )();
	}
}
