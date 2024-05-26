package en.player;

import dn.M;
import dn.heaps.input.ControllerAccess;
import dn.heaps.slib.HSprite;
import game.client.ControllerAction;
import game.client.GameClient;
import hxbit.NetworkHost;
import hxbit.NetworkSerializable;
import hxbit.Serializer;
import net.ClientController;
import ui.player.ItemCursorHolder;
import util.Assets;
import util.Const;
import util.Util;
import en.model.InventoryModel;
import en.model.PlayerModel;
import en.spr.EntityView;

using en.util.EntityUtil;

enum abstract PlayerActionState( Int ) {

	var Running;
	var Idle;
}

@:keep
class Player extends Entity {

	public static var inst : Player;

	public var ca : ControllerAccess<ControllerAction>;
	public var belt : ControllerAccess<ControllerAction>;

	/** server-side only **/
	@:s public var playerModel : PlayerModel;
	@:s public var inventoryModel : InventoryModel;
	@:s public var sprGroup : String;

	public static final speed = 0.35;

	var holdItemSpr : HSprite;

	public function new() {
		super();

		playerModel = new PlayerModel();
		inventoryModel = new InventoryModel();

		inventoryModel.holdItem = new ItemCursorHolder( this );

		// playerModel.actionState.syncBack = model.footX.syncBack = model.footY.syncBack = model.footZ.syncBack = model.dir.syncBack = false;
	}

	public override function alive() {
		ca = Main.inst.controller.createAccess();
		belt = Main.inst.controller.createAccess();

		// if ( model.controlId == net.Client.inst.uid ) {
		// inst = this;
		// GameClient.inst.cameraProc.camera.targetEntity.val = this;
		// GameClient.inst.player = this;
		// }

		super.alive();
	}

	override function createView() {
		// view = new EntityView(
		// 	this,
		// 	Assets.player,
		// 	Util.hollowScene
		// );
		// view.initTextLabel( playerModel.nickname );

		// if ( model.controlId == net.Client.inst.uid ) {
		// 	GameClient.inst.cameraProc.recenterCamera();
		// }
	}

	// override function applyTmx( ?v ) {
	// 	super.applyTmx();
	// if ( model.rigidBody != null ) {
	// 	model.rigidBody.setRotationFactor( new Vec3( 0, 0, 0 ) );
	// 	if ( inst == this ) {
	// 		new StructureInteractRestrictor().attach( this );
	// 		var deltaX = model.footX.val;
	// 		var deltaY = model.footY.val;
	// 		var deltaZ = model.footZ.val;
	// 		model.contactCb.postSolveSign.add( ( c ) -> {
	// 			model.forceRBCoords = true;
	// 			model.rigidBody._velX = model.rigidBody._velY = model.rigidBody._velZ = 0;
	// 		} );
	// 	}
	// }
	// }

	override public function update() @:privateAccess {

		// need to move this to distinct controller component
		if ( inst == this ) {
			var lx = ca.getAnalogValue2( MoveLeft, MoveRight );
			var ly = ca.getAnalogValue2( MoveDown, MoveUp );

			if ( Math.abs( lx ) == 1 && Math.abs( ly ) == 1 ) { // wasd cornering
				lx *= Math.cos( Const.FOURTY_FIVE_DEGREE_RAD );
				ly *= Math.sin( Const.FOURTY_FIVE_DEGREE_RAD );
			}

			var leftDist = M.dist( 0, 0, lx, ly );
			var leftPushed = leftDist >= 0.3;
			var leftAng = Math.atan2( ly, lx );

			// if ( leftPushed ) {
			// 	var s = leftDist * speed;

			// 	model.dx += Math.cos( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;
			// 	model.dy -= Math.sin( leftAng + Const.FOURTY_FIVE_DEGREE_RAD ) * s;

			// 	if ( lx < -0.3 && M.fabs( ly ) < 0.6 ) model.dir.val = 4;
			// 	else if ( ly < -0.3 && M.fabs( lx ) < 0.6 ) model.dir.val = 6;
			// 	else if ( lx > 0.3 && M.fabs( ly ) < 0.6 ) model.dir.val = 0;
			// 	else if ( ly > 0.3 && M.fabs( lx ) < 0.6 ) model.dir.val = 2;

			// 	if ( lx > 0.3 && ly > 0.3 ) model.dir.val = 1;
			// 	else if ( lx < -0.3 && ly > 0.3 ) model.dir.val = 3;
			// 	else if ( lx < -0.3 && ly < -0.3 ) model.dir.val = 5;
			// 	else if ( lx > 0.3 && ly < -0.3 ) model.dir.val = 7;
			// } else {
			// 	model.dx *= Math.pow( 0.6, tmod );
			// 	model.dy *= Math.pow( 0.6, tmod );
			// }
			// playerModel.actionState.val = isMoving ? Running : Idle;
		}

		// if ( inst != this && playerModel.actionState.val == Running ) onMove.dispatch();

		super.update();

		// if ( model.rigidBody != null ) {
		// 	if ( inst == this ) {
		// 		model.rigidBody._velX = model.dx * tmod / Boot.inst.deltaTime;
		// 		model.rigidBody._velY = model.dy * tmod / Boot.inst.deltaTime;
		// 		model.rigidBody._velZ = model.dz * tmod / Boot.inst.deltaTime;
		// 		if ( model.dx != 0 || model.dy != 0 || model.dz != 0 )
		// 			model.rigidBody.wakeUp();
		// 	} else {
		// 		model.rigidBody.setPosition(
		// 			new Vec3(
		// 				model.footX.val,
		// 				model.footY.val,
		// 				model.footZ.val
		// 			)
		// 		);
		// 	}
		// }
	}

	override function dispose() {
		super.dispose();
		if ( inst == this ) {
			// saveSettings();
			inst = null;
		}

		if ( GameClient.inst != null ) {
			if ( ca != null ) {
				ca.dispose();
				belt.dispose();
				ca = null;
			}
		}
	}
}
