package game.debug;

import imgui.ImGui;
import core.debug.imgui.node.intermediate.ImGuiNode;

class ImGuiDemo extends ImGuiNode {

	override function exec() {
		super.exec();
		ImGui.showDemoWindow();
	}
}
