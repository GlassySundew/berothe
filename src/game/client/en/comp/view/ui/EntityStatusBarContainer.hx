package game.client.en.comp.view.ui;

import dn.Col;
import h2d.Flow;
import h2d.ObjectFollower;
import h3d.scene.Object;
import ui.domkit.TextTooltipComp;

class EntityStatusBarContainer {

	var displayName : TextTooltipComp;

	public final root : ObjectFollower;

	final content : Flow;
	final viewComp : EntityViewComponent;

	var chatMessagesAmount : Int = 0;

	public function new(
		followObj3d : Object,
		view : EntityViewComponent,
		?parent
	) {
		this.viewComp = view;

		root = new ObjectFollower( followObj3d, parent );
		root.horizontalAlign = Right;
		root.verticalAlign = Bottom;
		root.pixelSnap = false;

		content = new Flow( root );
		content.horizontalAlign = Middle;
		// content.verticalAlign = Top;
		content.layout = Vertical;
		content.verticalSpacing = 4;

		createNameLabel();

		colorEnemy();

		// sayChatMessage( "adsdasdasdasdasdasdasdasuasdjbasdghjbasdbghjbjbasdjasd" );
		// sayChatMessage( "adsdasdasdasdasdasdasd" );
		// sayChatMessage( "adsdasdasdasdasdasdasdasuasdjbasdghjbasdbghjbjbasdjasd" );
		// sayChatMessage( "adsdasdasdasdasdasdasd" );
		// sayChatMessage( "adsdasdasdasdasdasdasdasuasdjbasdghjbasdbghjbjbasdjasd" );
		// sayChatMessage( "adsdasdasdasdasdasdasdasuasdjbasdghjbasdbghjbjbasdjasd" );
		// sayChatMessage( "adsdasdasdasdasdasdasdasuasdjbasdghjbasdbghjbjbasdjasd" );
	}

	public function colorEnemy() {
		displayName.shadowed_text.color = Col.fromInt( 0xeb8381 ).toShaderVec4().toVector4();
	}

	public function setDisplayNameVisibility( val : Bool ) {
		displayName.visible = val;
	}

	public function setDisplayName( value : String ) {
		displayName.label = value;
	}

	public function sayChatMessage( text : String ) {
		var textComp = new TextTooltipComp( text );
		// textComp.scale( 0.5 );
		content.addChild( textComp );
		viewComp.cooldown.setS(
			"chatMessage" + chatMessagesAmount++,
			5,
			() -> {
				textComp.remove();
				// chatMessagesAmount--;
			}
		);
	}

	function createNameLabel() {
		displayName = new TextTooltipComp( content );
	}
}
