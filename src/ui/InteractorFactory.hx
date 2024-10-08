package ui;

import signals.Signal;
import core.IProperty;
import graphics.ThrEventInteractive;
import graphics.ThreeDObjectNode;
import h3d.col.Collider;
import h3d.shader.FixedColor;
import util.BoolList;
import ui.tooltip.TooltipManager;
import ui.tooltip.TooltipMediatorBase;

class InteractorVO {

	public var doHighlight : Bool = false;
	public var highlightColor : Int;
	public var tooltipVO : TooltipMediatorBase;
	public var handCursor : Bool = true;

	public function new() {}
}

class InteractorFactory {

	public static function create<Pred>(
		interactorVO : InteractorVO,
		graphics : ThreeDObjectNode,
		?visibilitySignal : Signal<Bool>
	) : ThrEventInteractive {

		var int = createInteractor( graphics );
		graphics.addChild( int );

		if ( interactorVO.doHighlight ) {
			createHighlight( graphics, int, interactorVO.highlightColor );
		}

		if ( interactorVO.tooltipVO != null )
			TooltipManager.attach3d( interactorVO.tooltipVO, int );

		visibilitySignal?.add( ( val ) -> {
			int.visible = val;
		} );

		return int;
	}

	static function createInteractor( graphics : ThreeDObjectNode ) {
		var meshes = graphics.heapsObject.getMeshes();
		var collider = new GroupCollider( [
			for ( mesh in meshes ) mesh.getCollider()
		] );

		var int = new h3d.scene.Interactive( collider );

		return ThrEventInteractive.fromHeaps( int );
	}

	static function createHighlight(
		graphics : ThreeDObjectNode,
		int : ThrEventInteractive,
		color : Int,
	) {
		var materials = graphics.heapsObject.getMaterials();
		for ( material in materials ) {
			var m = material;
			var p = m.allocPass( "highlight" );
			p.culling = None;
			p.depthWrite = false;
			p.depthTest = LessEqual;
		}
		var shader = new FixedColor( color );
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
		int.onRemoved.add( removeHighlight );
	}
}
