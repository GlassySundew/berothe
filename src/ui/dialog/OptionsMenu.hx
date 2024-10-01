package ui.dialog;

import util.Settings;
import ui.core.ShadowedText;
import ui.core.TextInput;
import util.Assets;
import h2d.RenderContext;
import hxd.Event;
import h2d.Object;
import h2d.Flow;

class OptionsMenu extends PopupBase {

	var nicknameInput : TextInput;

	public function new( ?parent : Object ) {
		super( parent );

		centrizeContent();

		contentFlow.verticalSpacing = 5;

		var mm = new ShadowedText( Assets.fontPixel16, contentFlow );
		mm.scale( 1.5 );
		mm.text = "Options";

		contentFlow.addSpacing( 10 );

		var horFlow = new Flow( contentFlow );
		horFlow.layout = Horizontal;
		horFlow.verticalAlign = Top;

		var nickname = new ShadowedText( Assets.fontPixel16, horFlow );
		nickname.text = "username: ";

		nicknameInput = new TextInput( Assets.fontPixel16, horFlow );
		nicknameInput.text = Settings.inst.params.nickname;
		nicknameInput.onFocusLost = function ( e : Event ) {
			Settings.inst.params.nickname = nicknameInput.text;
			Settings.inst.saveSettings();
		}

		// nicknameInput.onKeyDown = function(e : Event) {
		// 	if ( e.keyCode == Key.ENTER ) {
		// 		Util.nickname = nicknameInput.text;
		// 		Util.saveSettings();
		// 		if ( onRemoveEvent != null ) onRemoveEvent();
		// 	}
		// }
	}

	override function update() {
		super.update();

		// if ( Main.inst.ca.isPressed( Escape ) ) {
		// 	remove();
		// }
	}

	override function onResize() {
		super.onResize();
	}
}
