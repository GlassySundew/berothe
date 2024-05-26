package en;

import util.Util;
import en.spr.EntityView;
import util.Assets;

// Just a helping indicator that should show if structure can be placed on
class StructureGhost extends Structure {

	public var canBePlaced : Bool = false;

	public function new() {
		super();


		// view.spr.alpha = .75;
		// model.cd.setS( "colorMaintain", 1 / 0 );
	}

	public function isValidToPlace() {
		// if ( checkCollsAgainstAll( false ) ) {
		// 	turnRed();
		// 	canBePlaced = false;
		// } else {
		// 	turnGreen();
		// 	canBePlaced = true;
		// }
	}

	public function turnGreen() {
		// view.colorAdd.setColor( 0x29621e );
	}

	public function turnRed() {
		// view.colorAdd.setColor( 0xbe3434 );
	}

	override function applyItem( item : Item ) {}

	override function emitDestroyItem( item : Item ) {}

	override function postUpdate() {
		super.postUpdate();
		isValidToPlace();
	}
}
