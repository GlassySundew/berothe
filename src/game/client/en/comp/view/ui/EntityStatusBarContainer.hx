package game.client.en.comp.view.ui;

import game.data.storage.DataStorage;
import game.data.storage.RuleStorage;
import rx.Subscription;
import rx.disposables.ISubscription;
import dn.Col;
import h2d.Flow;
import graphics.ObjectFollower;
import h3d.scene.Object;
import ui.domkit.TextTooltipComp;

typedef DisplayMessage = {
	var tooltipClip : TextTooltipComp;
	var messageVO : EntityMessageVO;
}

class EntityStatusBarContainer {

	public final root : ObjectFollower;

	final content : Flow;
	final viewComp : EntityViewComponent;
	final messages : Array<DisplayMessage> = [];

	var displayName : TextTooltipComp;
	var chatMessagesAmount : Int = 0;
	var subscription : ISubscription;

	var isFriendly : Bool;

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
		root.clampInScreen = true;

		content = new Flow( root );
		content.horizontalAlign = Middle;
		content.layout = Vertical;
		content.verticalSpacing = 1;

		createNameLabel();
	}

	public function setFriendliness( value : Bool ) {
		isFriendly = value;
		displayName.shadowed_text.color = Col.fromInt(
			isFriendly ? DataStorage.inst.rule.friendlyStatusBarColor : DataStorage.inst.rule.unfriendlyStatusBarColor
		).toShaderVec4().toVector4();

		for ( mes in messages ) {
			paintMessage( mes );
		}
	}

	public function setDisplayNameVisibility( val : Bool ) {
		displayName.visible = val;
	}

	public function setDisplayName( value : String ) {
		displayName.label = value;
	}

	public function setChatMessage( idx : Int, mesVO : EntityMessageVO ) {
		if ( mesVO != null ) {
			setChatMessageIdx( idx, mesVO );
		} else {
			removeChatMessageIdx( idx );
		}
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
			}
		);
	}

	function paintMessage( dispMes : DisplayMessage ) {
		var colorCode = switch dispMes.messageVO.type {
			case DAMAGE_TAKEN:
				isFriendly ? DataStorage.inst.rule.friendlyDamageTakenColor : DataStorage.inst.rule.unfriendlyDamageTakenColor;
			case SPEECH:
				DataStorage.inst.rule.speechColor;
		}
		dispMes.tooltipClip.color = Col.fromInt( colorCode ).toShaderVec4().toVector4();
	}

	function setChatMessageIdx( idx : Int, mesVO : EntityMessageVO ) {
		var textComp = new TextTooltipComp( mesVO.message );
		textComp.maxWidth = 350;
		content.addChild( textComp );
		textComp.shadowed_text.textLabel.textAlign = MultilineCenter;
		messages[idx] = {
			tooltipClip : textComp,
			messageVO : mesVO
		};
		paintMessage( messages[idx] );
	}

	function removeChatMessageIdx( idx : Int ) {
		var dispMessage = messages[idx];
		messages.remove( dispMessage );
		dispMessage.tooltipClip.remove();
	}

	function createNameLabel() {
		displayName = new TextTooltipComp( content );
	}
}
