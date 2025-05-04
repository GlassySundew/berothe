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

		createBg();
		centrizeContent();
		createCloseButton();

		contentFlow.verticalSpacing = 5;

		var mm = new ShadowedText( Assets.fontPixel16, contentFlow );
		mm.scale( 1.5 );
		mm.text = "Options";

		contentFlow.addSpacing( 10 );

		var horFlow = new Flow( contentFlow );
		horFlow.layout = Horizontal;
		horFlow.verticalAlign = Top;
	}
}
