package game.client.en.comp.view.ui;

import rx.Subscription;
import rx.disposables.ISubscription;
import dn.Col;
import h2d.Flow;
import graphics.ObjectFollower;
import h3d.scene.Object;
import ui.domkit.TextTooltipComp;

class EntityStatusBarContainer {

	var displayName : TextTooltipComp;

	public final root : ObjectFollower;

	final content : Flow;
	final viewComp : EntityViewComponent;

	var chatMessagesAmount : Int = 0;
	var subscription : ISubscription;

	public function new(
		followObj3d : Object,
		view : EntityViewComponent,
		?parent
	) {
		this.viewComp = view;

		root = new ObjectFollower( followObj3d, parent );
		root.horizontalAlign = Middle;
		root.verticalAlign = Bottom;
		root.cameraRelative = true;
		root.pixelSnap = false;

		content = new Flow( root );
		content.horizontalAlign = Middle;
		content.layout = Vertical;
		content.verticalSpacing = 1;
		content.y += 15;

		createNameLabel();
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
