package game.debug;

import game.core.rules.overworld.location.physics.Types.ThreeDeeVectorType;
import game.core.rules.overworld.location.physics.IDebugDraw;
import dn.Col;
import h3d.col.Point;
import h3d.scene.Graphics;
import h3d.scene.Object;
import oimo.common.Vec3;
import oimo.dynamics.common.DebugDraw;

class HeapsOimophysicsDebugDraw extends DebugDraw implements IDebugDraw {

	public final graphics : Graphics;

	public function new( parent : Object ) {
		super();
		graphics = new Graphics( parent );
		graphics.material.props = h3d.mat.MaterialSetup.current.getDefaults( "ui" );

	}

	public function setVisibility( value : Bool ) {
		graphics.visible = value;
	}

	override inline function point( v : ThreeDeeVectorType, color : ThreeDeeVectorType ) {
		graphics.lineStyle( 2, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );
		graphics.drawLine( new Point( v.x, v.y, v.z ), new Point( v.x, v.y, v.z ) );
	}

	override inline function triangle( v1 : ThreeDeeVectorType, v2 : ThreeDeeVectorType, v3 : ThreeDeeVectorType, n1 : ThreeDeeVectorType, n2 : ThreeDeeVectorType, n3 : ThreeDeeVectorType, color : ThreeDeeVectorType ) {
		graphics.lineStyle( 2, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );

		graphics.drawLine( new Point( v1.x, v1.y, v1.z ), new Point( v2.x, v2.y, v2.z ) );
		graphics.drawLine( new Point( v2.x, v2.y, v2.z ), new Point( v3.x, v3.y, v3.z ) );
		graphics.drawLine( new Point( v3.x, v3.y, v3.z ), new Point( v1.x, v1.y, v1.z ) );
	}

	override inline function line( v1 : ThreeDeeVectorType, v2 : ThreeDeeVectorType, color : ThreeDeeVectorType ) {
		graphics.lineStyle( 2, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );

		graphics.drawLine( new Point( v1.x, v1.y, v1.z ), new Point( v2.x, v2.y, v2.z ) );
	}
}
