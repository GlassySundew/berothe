package game.client.level.physics;

import util.Settings;
import oimo.dynamics.World;
import game.debug.HeapsOimophysicsDebugDraw;

class ClientPhysics {

	var physicsDebugView : HeapsOimophysicsDebugDraw;

	public final world : World;

	public function new( world : World ) {
		this.world = world;
	}

	public function debugInit() {
		physicsDebugView = new HeapsOimophysicsDebugDraw( Boot.inst.s3d );
		world.setDebugDraw( physicsDebugView );
		physicsDebugView.setVisibility( Settings.inst.params.debug.physicsDebugVisible );

		Settings.inst.params.debug.physicsDebugVisible.addOnValue(
			( value ) -> physicsDebugView.setVisibility( value )
		);
	}

	public function step( deltaTime : Float ) {
		world.step( deltaTime );

		if ( physicsDebugView != null && physicsDebugView.graphics.visible ) {
			Std.downcast( physicsDebugView, HeapsOimophysicsDebugDraw ).graphics.clear();
			inline world.debugDraw();
		}
	}
}
