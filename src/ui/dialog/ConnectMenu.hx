package ui.dialog;

import h2d.Flow;
import h2d.Object;
import h2d.RenderContext;
import h2d.domkit.Style;
import hxd.Res;
import net.Client;
import ui.core.TextInput;
import ui.domkit.element.ButtonFlowComp;
import ui.domkit.element.ShadowedTextComp;
import ui.domkit.element.TextButtonComp;
import ui.domkit.element.TextInputComp;
import util.tools.Settings;

class ConnectComp extends Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC = 
		<connect-comp layout="vertical" vspacing="10">
			<shadowed-text( "Connect" ) scale="1.5"/>

			<flow 
				layout="horizontal" 
				hspacing="10" 
				valign="middle" 
				content-valign="middle" 
				padding-top="7"
			> 
				<shadowed-text( "ip: " ) valign="middle" />
				<text-input public id="ipInput" background-color-prop={0x80808080} input-width-prop="200" width="200" />
			</flow>
			
			<flow layout="horizontal" hspacing="5">
				<text-button( "connect" ) public id="connect" />
				<text-button( "cancel", ( e ) -> {}, 0xFFA54A4A, 0xFF303030 ) public id="cancel" />
			</flow>
		</connect-comp>
	
	// @formatter:on
	var style : Style;

	public function new( ?parent ) {
		super( parent );
		initComponent();

		#if !debug
		localConnect.visible = false;
		#end

		style = new Style();
		style.load( Res.domkit.connectMenu );
		style.addObject( this );
	}

	override function sync( ctx : RenderContext ) {
		super.sync( ctx );
		style.sync();
	}
}

class ConnectMenu extends FocusMenu {

	public var textInput : TextInput;

	public function new( ?parent : Object ) {
		super( parent );
		centrizeContent();

		var connectComp = new ConnectComp( contentFlow );
		connectComp.connect.onClick = ( e ) -> {
			MainMenu.hide();

			Client.inst.connect( connectComp.ipInput.text,
				() -> trace( "failed connection" ) );
			destroy();
		}

		connectComp.cancel.onClick = ( e ) -> {
			destroy();
		};
	}
}
