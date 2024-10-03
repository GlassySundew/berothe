package ui;

import util.GameUtil;
import util.Util;
import dn.Tweenie.TType;
import ui.core.TextButton;
import ui.core.ShadowedText;
import net.Client;
import game.net.client.GameClient;
import util.Assets;
import dn.Process;
import h2d.Flow;
import h2d.Graphics;
import h2d.Object;
import ui.dialog.PopupBase;
import ui.dialog.OptionsMenu;
import ui.dialog.SaveManager;

class PauseMenu extends PopupBase {

	var pausableProcess : Process;

	public function new( pausableProcess : Process, ?parent : h2d.Object, ?parentProcess : Process ) {
		super( parent, parentProcess );
		pausableProcess.pause();
		this.pausableProcess = pausableProcess;

		createBg();
		centrizeContent( 0 );
		contentFlow.padding = 10;

		initContent();
	}

	function initContent() {

		new TextButton( "continue", ( e ) -> {
			destroy();
		}, contentFlow );

		new TextButton( "options", ( e ) -> {
			new OptionsMenu( root );
		}, contentFlow );

		new TextButton( "exit to main menu", ( e ) -> {
			Client.inst.sendMessage( Disconnect );
			GameClient.inst.destroy();

			// TODO make
			// Save.inst.disconnect();

			new MainMenu( Main.inst.root );
			destroy();
		}, contentFlow );

		Boot.inst.renderer.overlayBlurEnabled = true;
		tw.createS(
			Boot.inst.renderer.overlayBlurRadius,
			12,
			TLinear,
			0.6
		);
	}

	override function onDispose() {
		super.onDispose();

		pausableProcess.resume();

		Boot.inst.renderer.overlayBlurRadius = 0;
		Boot.inst.renderer.overlayBlurEnabled = false;
	}

	override function onResize() {
		super.onResize();

		// if ( vertFlow != null ) {
		// 	vertFlow.minWidth = vertFlow.maxWidth = wScaled;
		// 	vertFlow.minHeight = vertFlow.maxHeight = hScaled;
		// 	vertFlow.paddingTop = -Std.int(hScaled / 4);
		// }

		// backgroundGraphics.scaleX = wScaled / 3;
		// backgroundGraphics.scaleY = hScaled;
	}
}
