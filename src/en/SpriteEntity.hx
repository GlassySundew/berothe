package en;

import util.Util;
import en.spr.EntityView;
import util.Assets;

class SpriteEntity extends Structure {

	@:s var spriteGroup : String;

	public function new( sprite : String ) {
		spriteGroup = sprite;
		super();
	}

	override function init() {

		super.init();
		// mesh.isLong=true;
		// mesh.isoHeight=mesh.isoWidth=1;
	}

	public override function alive() {
		// view = new EntityView(
		// 	this,
		// 	Assets.structures,
		// 	Util.hollowScene,
		// 	spriteGroup
		// );
		super.alive();
	}

	override function postUpdate() {
		super.postUpdate();
	}
}
