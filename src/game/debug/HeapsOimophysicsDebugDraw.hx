package game.debug;

import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import game.domain.overworld.location.physics.IDebugDraw;
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

	override inline function point( v : ThreeDeeVector, color : ThreeDeeVector ) {
		graphics.lineStyle( 10, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );

		// drawing little cross because graphics does not support single point
		graphics.drawLine( new Point( v.x - 0.2, v.y, v.z - 0.2 ), new Point( v.x + 0.2, v.y, v.z + 0.2 ) );
		graphics.drawLine( new Point( v.x, v.y - 0.2, v.z - 0.2 ), new Point( v.x, v.y + 0.2, v.z + 0.2 ) );
	}

	override inline function triangle( v1 : ThreeDeeVector, v2 : ThreeDeeVector, v3 : ThreeDeeVector, n1 : ThreeDeeVector, n2 : ThreeDeeVector, n3 : ThreeDeeVector, color : ThreeDeeVector ) {
		graphics.lineStyle( 3, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );

		graphics.drawLine( new Point( v1.x, v1.y, v1.z ), new Point( v2.x, v2.y, v2.z ) );
		graphics.drawLine( new Point( v2.x, v2.y, v2.z ), new Point( v3.x, v3.y, v3.z ) );
		graphics.drawLine( new Point( v3.x, v3.y, v3.z ), new Point( v1.x, v1.y, v1.z ) );
	}

	override inline function line( v1 : ThreeDeeVector, v2 : ThreeDeeVector, color : ThreeDeeVector ) {
		graphics.lineStyle( 3, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );

		graphics.drawLine( new Point( v1.x, v1.y, v1.z ), new Point( v2.x, v2.y, v2.z ) );
	}
}
