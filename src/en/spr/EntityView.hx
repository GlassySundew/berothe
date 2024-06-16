package en.spr;

import util.GameUtil;
import dn.heaps.slib.SpriteLib;
import game.client.GameClient;
import h2d.Object;
import h2d.Tile;
import h3d.mat.Texture;
import h3d.scene.Mesh;
import shader.DepthOffset;
import shader.Perpendicularizer;
import ui.domkit.TextLabelComp;
import util.Assets;
import util.BoolList;
import util.Const;
import util.Util;

class EntityView {

	public var colorAdd : h3d.Vector;
	public var mesh : Mesh;
	public var tmpDt : Float;
	public var tmpCur : Float;
	public var curFrame : Float = 0;
	public var depthOffset : DepthOffset;
	public var perpendicularizer : Perpendicularizer;

	/**
		из-за того, что метод отрисовки, который я добавил в том виде, какой он есть 
		(тайл из spr просто передаётся в mesh ), всякие эффекты и шейдеры не будут 
		работать если forceDrawTo не будет true (спрайт будет рисоваться через spr.drawTo())
	**/
	public var forceDrawTo : Bool = false;
	public var refreshTile : Bool = false;

	/**
		реальный x и y центра спрайта, не в процентах
	**/
	public var pivot : {
		x : Float,
		y : Float
	};
	public var drawToBoolStack : BoolList = new BoolList();

	@:allow( en.Entity )
	private var tex : Texture;
	private var texTile : Tile;
	private var nicknameLabel : TextLabelComp;

	var debugObjs : Array<h3d.scene.Object> = [];

	var entity : Entity;

	public function new(
		entity : Entity,
		lib : SpriteLib,
		parent : Object,
		?group : String
	) {
		this.entity = entity;
		colorAdd = new h3d.Vector();
		init();
	}

	function init() {}

	public function destroy() {
		if ( mesh != null ) {
			mesh.remove();
		}
		for ( i in debugObjs ) i.remove();

		tex.dispose();
		if ( nicknameLabel != null ) {
			nicknameLabel.remove();
		}
	}

	/** generate nickname text **/
	public function initTextLabel( displayText : String ) {
		if ( nicknameLabel != null ) nicknameLabel.remove();
		nicknameLabel = new TextLabelComp( displayText, Assets.fontPixel );
		GameClient.inst.root.add( nicknameLabel, Const.DP_UI_NICKNAMES );
		nicknameLabel.scale( 1 / Const.UI_SCALE );
		// entity.onMove.add( refreshNicknameLabel );
		GameClient.inst.cameraProc.onMove.add( refreshNicknameLabel );
		GameClient.inst.cameraProc.onFrame.add(() -> {
			GameClient.inst.cameraProc.delayer.addF( refreshNicknameLabel, 1 );
		} );
		GameClient.inst.cameraProc.onFrame.repeat( 1 );
	}

	function refreshNicknameLabel() {
		if ( nicknameLabel != null ) {
			var s3dCam = Boot.inst.s3d.camera;
			var entityPt = s3dCam.project(
				entity.x.val,
				entity.y.val,
				entity.z.val,
				GameUtil.wScaled,
				GameUtil.hScaled,
				false
			);

			nicknameLabel.x = entityPt.x - nicknameLabel.outerWidth / 2 / Const.UI_SCALE;
			nicknameLabel.y = entityPt.y;
		}
	}

	/** update debug centers and colliders poly**/
	public function updateDebugDisplay() {
		#if entity_centers_debug
		var sphere = new Sphere( 0xf12106, 1, false, mesh );
		sphere.material.mainPass.wireframe = true;
		sphere.material.shadows = false;
		sphere.material.mainPass.depth( true, Less );
		sphere.material.mainPass.addShader( depthOffset );
		debugObjs.push( sphere );
		#end

		#if colliders_debug
		LevelView.inst.oimoDebug.registerEntity( entity );
		#end
	}

	public function blink( ?c = 0xffffff ) {
		colorAdd.setColor( c );
	}
}
