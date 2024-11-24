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
				<text-input 
					public id = "ipInput" 
					background-color-prop = {0x80808080} 
					max-width = "200" 
					width = "200" 
				/>
			</flow>
			
			<flow layout="horizontal" hspacing="5">
				<text-button( "connect" ) public id="connect" />
				<text-button( "cancel", ( e ) -> {}, 0xFF2E2E3A, 0xFF231818 ) public id="cancel" />
			</flow>
		</connect-comp>
	
	// @formatter:on
	var style : Style;

	public function new( ?parent ) {
		super( parent );
		initComponent();

		style = new Style();
		style.load( Res.domkit.connectMenu );
		style.addObject( this );
	}

	override function sync( ctx : RenderContext ) {
		super.sync( ctx );
		style.sync();
	}
}

class ConnectMenu extends PopupBase {

	public var textInput : TextInput;

	public function new( ?parent : Object ) {
		super( parent );
		centrizeContent();
		createCloseButton();

		createBg();

		#if !debug
		PopupBase.destroyByPopupType( MainMenu );

		Client.inst.connect(
			'51.68.220.173',
			() -> trace( "failed connection" )
		);
		destroy();
		#end

		
		var connectComp = new ConnectComp( contentFlow );
		connectComp.connect.onClick = ( e ) -> {
			PopupBase.destroyByPopupType( MainMenu );

			Client.inst.connect(
				connectComp.ipInput.text,
				() -> trace( "failed connection" )
			);
			destroy();
		}

		connectComp.cancel.onClick = ( e ) -> {
			destroy();
		};
	}
}
