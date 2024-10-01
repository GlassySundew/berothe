package ui.dialog;

import hxd.Event;
import h2d.Flow;
import h2d.Object;
import ui.domkit.element.ShadowedTextComp;
import ui.domkit.element.TextButtonComp;


class ConfirmDialog extends PopupBase {

	public function new( message : String, onOkBtn : Event -> Void, ?onCancelBtn : Event -> Void, ?parent : Object ) {
		super( parent );
		centrizeContent();

		// new ConfirmComp( message,
		// 	( e ) -> {
		// 		onOkBtn( e );
		// 		destroy();
		// 	},
		// 	onCancelBtn == null ? onCancelBtn : ( e ) -> {
		// 		onCancelBtn( e );
		// 		destroy();
		// 	},
		// 	contentFlow
		// );
	}

	override function backgroundOnClick( e ) {}
}
