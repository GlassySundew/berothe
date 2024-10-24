package game.client.en.comp.view.ui;

import dn.Col;
import h2d.ObjectFollower;
import h2d.RenderContext;
import h3d.scene.Object;
import ui.tooltip.text.TooltipTextRendererClip;
import h2d.Flow;
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
		content.verticalAlign = Bottom;
		content.layout = Vertical;
		content.verticalSpacing = 4;

		createNameLabel();

		colorEnemy();
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
		var text = new TextTooltipComp( text );
		text.scale( 0.5 );
		content.addChild( text );
		var chatMessageCdId = 'chatmessage_${chatMessagesAmount++}';
		viewComp.cooldown.setS( '$chatMessageCdId', 6 );
		viewComp.cooldown.onComplete( '$chatMessageCdId', text.remove );
	}

	function createNameLabel() {
		displayName = new TextTooltipComp( content );
	}
}
