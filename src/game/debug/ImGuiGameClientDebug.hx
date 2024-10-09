package game.debug;

import util.Settings;
import game.debug.accessor.MutablePropertyAccessor;
import game.debug.accessor.render.OrthographicsAccessor;
import game.debug.accessor.physics.PhysicsDebugViewAccessor;
import game.debug.accessor.camera.FovAccessor;
import game.debug.accessor.camera.ZFarKAccessor;
import game.debug.accessor.camera.ZNearKAccessor;
import game.debug.accessor.camera.ZFarAccessor;
import game.debug.accessor.camera.ZNearAccessor;
import game.net.client.GameClient;
import h3d.col.Bounds;
import core.debug.imgui.node.ButtonNode;
import hl.Ref;
import core.debug.imgui.ImGuiDebug;
import core.debug.imgui.node.CheckboxNode;
import core.debug.imgui.node.CollapsingHeaderNode;
import core.debug.imgui.node.DragDoubleNode;
import core.debug.imgui.node.DragIntNode;
import core.debug.imgui.node.SeparatorTextNode;
import core.debug.imgui.node.WindowNode;
import dn.Process;
import imgui.ImGui;
import imgui.ImGuiDrawable;
import util.Const;
import game.client.debug.accessor.camera.*;
import game.client.debug.accessor.physics.*;
import game.debug.accessor.render.SAOBiasAccessor;
import game.debug.accessor.render.SAOBlurLinearityAccessor;
import game.debug.accessor.render.SAOBlurQualityAccessor;
import game.debug.accessor.render.SAOBlurRadiusAccessor;
import game.debug.accessor.render.SAOIntensityAccessor;
import game.debug.accessor.render.SAORadiusAccessor;
import game.debug.accessor.render.SAOSamplesAccessor;
import game.debug.accessor.render.ShadowPowerAccessor;
import game.debug.accessor.render.ShadowSizeAccessor;
import game.debug.accessor.render.ShadowBlurQualityAccessor;
import game.debug.accessor.render.ShadowBlurRadiusAccessor;

@:access( h3d.scene.CameraController )
class ImGuiGameClientDebug extends ImGuiDebug {

	public function new( parent : Process ) {
		super( parent );

		this.drawable = new ImGuiDrawable( GameClient.inst.root );
		drawable.scale( 1 / Const.UI_SCALE );
		rootNode = new WindowNode( "game debug" );

		// rootNode.addChild( new ImGuiDemo() );

		Main.inst.root.add( drawable, Const.DP_IMGUI );
		var cameraHeader = new CollapsingHeaderNode( "camera", rootNode );

		new DragDoubleNode( "zNear", new ZNearAccessor(), 0.1, 0.1, 10000, cameraHeader );
		new DragDoubleNode( "zFar", new ZFarAccessor(), 1, 0, 400000, cameraHeader );
		new DragDoubleNode( "zNearK", new ZNearKAccessor(), 0.001, 0.0000001, 180, cameraHeader );
		new DragDoubleNode( "zFarK", new ZFarKAccessor(), 0.1, 0.01, 9999, cameraHeader );
		new DragDoubleNode( "fov", new FovAccessor(), 0.1, 0.000, 180, cameraHeader );
		new ButtonNode( "untarget", GameClient.inst.cameraProc.untarget, cameraHeader );
		new CheckboxNode( "toggleOrtho", new OrthographicsAccessor(), cameraHeader );

		var physicsHeader = new CollapsingHeaderNode( "physics", rootNode );
		new CheckboxNode(
			"physics debug view",
			new MutablePropertyAccessor( Settings.inst.params.debug.physicsDebugVisible ),
			physicsHeader
		);

		var networkHeader = new CollapsingHeaderNode( "network", rootNode );
		new CheckboxNode(
			"toggleChunksView",
			new MutablePropertyAccessor( Settings.inst.params.debug.chunksDebugVisible ),
			networkHeader
		);

		var renderHeader = new CollapsingHeaderNode( "render", rootNode );
		new DragIntNode( "sao samples", new SAOSamplesAccessor(), 2, 101, renderHeader );
		new DragDoubleNode( "sao bias", new SAOBiasAccessor(), 0.0005, 0, 1, renderHeader );
		new DragDoubleNode( "sao intensity", new SAOIntensityAccessor(), 0.1, 0, 10, renderHeader );
		new DragDoubleNode( "sao sample radius", new SAORadiusAccessor(), 0.1, -100, 100, renderHeader );

		new DragDoubleNode( "sao blur radius", new SAOBlurRadiusAccessor(), 0.1, 0, 10, renderHeader );
		new DragDoubleNode( "sao blur quality", new SAOBlurQualityAccessor(), 0.1, -20, 20, renderHeader );
		new DragDoubleNode( "sao blur linearity", new SAOBlurLinearityAccessor(), 0.1, -20, 20, renderHeader );

		new SeparatorTextNode( "Shadow", renderHeader );

		new DragDoubleNode( "shadow power", new ShadowPowerAccessor(), 0.1, 0, 80, renderHeader );
		new DragIntNode( "shadow size", new ShadowSizeAccessor(), 1, 6, 12, renderHeader );
		new DragDoubleNode( "shadow blur quality", new ShadowBlurQualityAccessor(), 0.1, 0, 2, renderHeader );
		new DragDoubleNode( "shadow blur radius", new ShadowBlurRadiusAccessor(), 0.1, 0, 10, renderHeader );
	}

	override function update() {
		super.update();
	}
}
