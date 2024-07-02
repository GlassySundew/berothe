package en;

import core.MutableProperty;
import net.NSMutableProperty;
import game.net.client.GameClient;
import dn.legacy.Color;
import util.Const;
import dn.Tweenie.TType;
import util.Util;
import shader.DepthOffset;
import en.player.Player;

import h2d.Object;
import h2d.filter.Glow;
import h3d.col.Point;
import h3d.prim.Polygon;
import h3d.scene.Mesh;
import hxGeomAlgo.EarCut;
import hxGeomAlgo.HxPoint;
import hxGeomAlgo.MarchingSquares;
import hxGeomAlgo.PolyTools.Tri;
import hxPixels.Pixels;
import hxd.IndexBuffer;
import ui.player.ButtonIcon;
import ui.s3d.EventInteractive;

/**
	An interactive entity
**/
class InteractableEntity extends Entity {

	public var interact : EventInteractive;

	public var reachable = new MutableProperty<Bool>( false );

	@:s public var canBeInteractedWith : NSMutableProperty<Bool> = //
		new NSMutableProperty<Bool>( false );

	var highlightingColor : String;
	var polyPrim : Polygon;
	var buttonIcon : ButtonIcon;
	var filter : Glow;
	var idx : IndexBuffer;
	var translatedPoints : Array<Point> = [];
	var polygonized : Array<Tri>;
	var points : Array<HxPoint>;

	function new() {
		super();
	}

	public override function init() {
		super.init();
	}

	override function alive() {
		super.alive();

		canBeInteractedWith.addOnValue( ( v ) -> {
			if ( !v ) {
				reachable.val = false;
			}
		} );
		reachable.addOnValue( ( v ) -> {
			if ( interact != null ) interact.visible = v;
			if ( !v ) {
				turnOffHighlight();
				if ( buttonIcon != null ) buttonIcon.remove();
			}
		} );
	}

	override function createView() {
		super.createView();
		// var pixels = Pixels.fromBytes(
		// 	view.tex.capturePixels().bytes,
		// 	Std.int( view.spr.tile.width ),
		// 	Std.int( view.spr.tile.height )
		// );
		// points = new MarchingSquares( pixels ).march();
		// polygonized = ( EarCut.triangulate( points ) );

		// for ( i in polygonized )
		// 	for ( j in i )
		// 		translatedPoints.push( new Point( j.x, 0, j.y ) );

		// idx = new IndexBuffer();
		// for ( poly in 0...polygonized.length ) {
		// 	idx.push( findVertexNumberInArray(
		// 		polygonized[poly][0], translatedPoints
		// 	) );
		// 	idx.push( findVertexNumberInArray(
		// 		polygonized[poly][1], translatedPoints
		// 	) );
		// 	idx.push( findVertexNumberInArray(
		// 		polygonized[poly][2], translatedPoints
		// 	) );
		// }

		// polyPrim = new Polygon( translatedPoints, idx );
		// interact = new EventInteractive( polyPrim.getCollider(), view.mesh );

		// interact.rotate( 0, hxd.Math.degToRad( 180 ), hxd.Math.degToRad( 90 ) );

		// if ( model.tmxObj != null && model.tmxObj.flippedHorizontally )
		// 	interact.scaleX = -1;

		// var highlightColor = null;
		// if ( highlightColor == null ) highlightColor = "ffffffff";

		// filter = new h2d.filter.Glow(
		// 	Color.hexToInt(
		// 		if ( highlightingColor != null ) highlightingColor
		// 		else highlightColor
		// 	),
		// 	1.2, 4, 1, 1.5, true
		// );

		// Main.inst.delayer.addF(() -> {
		// 	rebuildInteract();
		// 	#if interactive_debug
		// 	debugInteract();
		// 	#end
		// }, 10 );
	}

	function debugInteract() {
		polyPrim.addUVs();
		polyPrim.addNormals();

		var isoDebugMesh = new Mesh( polyPrim, interact );
		isoDebugMesh.material.color.setColor( 0xc09900 );
		isoDebugMesh.material.shadows = false;
		// var depthOffset = new DepthOffset( view.depthOffset.offset - 0.002 );
		// isoDebugMesh.material.mainPass.addShader( view.perpendicularizer );
		// isoDebugMesh.material.mainPass.addShader( depthOffset );
		// isoDebugMesh.material.mainPass.wireframe = true;
	}

	/**only x flipping is supported yet**/
	public function rebuildInteract() {
		@:privateAccess
		// polyPrim.translate(
		// 	-polyPrim.translatedX,
		// 	0,
		// 	-polyPrim.translatedZ
		// );
		// interact.scaleX = view.spr.scaleX;
		// var facX = 
		// 	if ( model.flippedX ) 1 - view.spr.pivot.centerFactorX
		// 	else view.spr.pivot.centerFactorX;
		// polyPrim.translate(
		// 	-view.spr.tile.width * facX,
		// 	0,
		// 	-view.spr.tile.height * view.spr.pivot.centerFactorY
		// );
		interact.shape = polyPrim.getCollider();
	}

	public function turnOnHighlight( ?v ) {
		// view.spr.filter = filter;
		// view.forceDrawTo = true;
		// filter.enable = true;
		// model.cd.setS( "keyboardIconInit", .4 );
		// model.cd.setS( "interacted", Math.POSITIVE_INFINITY );
	}

	public function turnOffHighlight() {
		// model.cd.unset( "interacted" );
		// view.forceDrawTo = false;
		// view.spr.filter = null;
		// filter.enable = false;
		// if ( buttonIcon != null ) buttonIcon.remove();
	}

	function updateKeyIcon() {
		// if (
		// 	!model.cd.has( "keyboardIconInit" )
		// 	&& model.cd.has( "interacted" ) //
		// ) {
		// 	var pos = {
		// 		Boot.inst.s3d.camera.project(
		// 			view.mesh.x,
		// 			0,
		// 			view.mesh.z,
		// 			GameUtil.wScaled,
		// 			GameUtil.hScaled
		// 		);
		// 	}
		// 	model.cd.unset( "interacted" );
		// 	buttonIcon = new ButtonIcon( pos.x, pos.y );
		// 	model.tw.createS(
		// 		buttonIcon.container.icon.alpha,
		// 		0 > 1,
		// 		TType.TEaseIn,
		// 		.4
		// 	);
		// }
		
		// if ( buttonIcon != null ) {
		// 	var pos = Boot.inst.s3d.camera.project(
		// 		view.mesh.x,
		// 		0,
		// 		view.mesh.z,
		// 		GameUtil.wScaled,
		// 		GameUtil.hScaled
		// 	);

		// 	buttonIcon.centerFlow.x = pos.x - 1;
		// 	buttonIcon.centerFlow.y = pos.y - 100 / Const.UI_SCALE;

		// 	buttonIcon.container.icon.tile = buttonIcon.buttonSpr.tile;
		// }
	}

	function findVertexNumberInArray(
		point : Dynamic,
		findIn : Array<Point>
	) : Int {
		for ( pts in 0...findIn.length ) {
			if (
				point.x == findIn[pts].x
				&& point.y == findIn[pts].z
			)
				return pts;
		}
		throw "Not part of this array";
	}

	override function dispose() {
		super.dispose();

		interact.remove();
		buttonIcon.remove();
		filter = null;
		polyPrim.dispose();
	}
}
