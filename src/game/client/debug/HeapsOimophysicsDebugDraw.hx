package game.client.debug;

import dn.Col;
import h3d.col.Point;
import h3d.scene.Graphics;
import h3d.scene.Object;
import oimo.common.Vec3;
import oimo.dynamics.common.DebugDraw;

class HeapsOimophysicsDebugDraw extends DebugDraw {

	public final graphics : Graphics;

	public function new( parent : Object ) {
		super();
		graphics = new Graphics( parent );
		graphics.material.mainPass.depthTest = Always;
	}

	public function setVisibility( value : Bool ) {
		graphics.visible = value;
	}

	override inline function point( v : Vec3, color : Vec3 ) {
		graphics.lineStyle( 2, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );
		graphics.drawLine( new Point( v.x, v.y, v.z ), new Point( v.x, v.y, v.z ) );
	}

	override inline function triangle( v1 : Vec3, v2 : Vec3, v3 : Vec3, n1 : Vec3, n2 : Vec3, n3 : Vec3, color : Vec3 ) {
		graphics.lineStyle( 2, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );

		graphics.drawLine( new Point( v1.x, v1.y, v1.z ), new Point( v2.x, v2.y, v2.z ) );
		graphics.drawLine( new Point( v2.x, v2.y, v2.z ), new Point( v3.x, v3.y, v3.z ) );
		graphics.drawLine( new Point( v3.x, v3.y, v3.z ), new Point( v1.x, v1.y, v1.z ) );
	}

	override inline function line( v1 : Vec3, v2 : Vec3, color : Vec3 ) {
		graphics.lineStyle( 2, Col.fromRGBi( Std.int( color.x * 255 ), Std.int( color.y * 255 ), Std.int( color.z * 255 ), 255 ) );

		graphics.drawLine( new Point( v1.x, v1.y, v1.z ), new Point( v2.x, v2.y, v2.z ) );
	}
}
