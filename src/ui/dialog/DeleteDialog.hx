package ui.dialog;

import util.Settings;
import ui.core.TextButton;
import util.Assets;
import net.Client;
import dn.Process;
import h2d.Flow;
import h2d.Object;
import ui.domkit.TextTooltipComp;

class DeleteDialog extends Dialog {

	public function new( name : String, ?parent : Object, ?parentProcess : Process ) {
		super( parent, parentProcess );

		new TextTooltipComp( 'Are you sure?', Assets.fontPixel16, contentFlow );

		var horizontalFlow = new Flow( contentFlow );
		horizontalFlow.layout = Horizontal;
		horizontalFlow.horizontalSpacing = 10;

		new TextButton( "yes", ( e ) -> {
			destroy();

			SaveManager.generalDelete( name );
		}, 0xd36363, 0x855a5a, horizontalFlow );

		new TextButton( "no", ( e ) -> {
			destroy();
		}, horizontalFlow );

		centrizeContent();
	}
}
