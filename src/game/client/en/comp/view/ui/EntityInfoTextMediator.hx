package game.client.en.comp.view.ui;

import rx.disposables.ISubscription;
import game.client.ControllerAction.EscapeAction;
import hxd.Key;
import dn.heaps.input.ControllerAccess;
import game.net.client.GameClient;
import h2d.Flow;
import h2d.Object;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import net.ClientController.InfoMessageType;

class AdvancedStatInfoTextMediator extends EntityInfoTextMediator {

	public function new(
		entityModel : EntityModelComponent,
		parent : Object
	) {
		super( [SKILLS], entityModel, parent );
	}

	public function dispose() {
		
	}
}

class EntityInfoTextMediator {

	final viewMediator : EntityInfoTextViewMediator;
	final entityModel : EntityModelComponent;
	final escapeCA : ControllerAccess<EscapeAction>;

	public function new(
		infoTypes : Array<InfoMessageType>,
		entityModel : EntityModelComponent,
		parent : Object
	) {
		escapeCA = Main.inst.escapeController.createAccess();
		viewMediator = new EntityInfoTextViewMediator( this, parent );
		this.entityModel = entityModel;

		GameClient.inst.infoMessageStream.then( ( stream ) -> {
			stream.observe( infoMsg -> {
				var corresp = infoTypes.filter(
					msgType -> Type.enumIndex( infoMsg ) == Type.enumIndex( msgType )
				)[0];
				if ( corresp == null ) return;

				inline function clearText() {
					viewMediator.comp.label.text = "";
				}

				inline function setText( text : String ) {
					viewMediator.comp.label.text = text;
					var sub : ISubscription = null;
					sub = Main.inst.onUpdate.add(
						() -> {
							if ( escapeCA.isPressed( ESCAPE ) ) {
								sub.unsubscribe();
								GameClient.inst.delayer.addF(() -> escapeCA.releaseExclusivity(), 1 );
								clearText();
							}
						} );
					escapeCA.takeExclusivity();
				}

				switch infoMsg {
					case SKILLS: setText( formatSkillsOutput() );
					case TEXT( text ): setText( text );
				}
			} );
		} );
	}

	function formatSkillsOutput() : String {
		if ( entityModel.skills.isEmpty() ) {
			return Data.locale.get( Data.LocaleKind.no_skills ).text;
		}
		var result = "Skills: \n";
		for ( skill in entityModel.skills.container ) {
			result += skill.getStatus();
		}

		return result;
	}
}

class EntityInfoTextViewMediator {

	public final comp : EntityInfoTextComp;
	final mediator : EntityInfoTextMediator;

	public function new(
		mediator : EntityInfoTextMediator,
		?parent : Object
	) {
		this.mediator = mediator;
		comp = new EntityInfoTextComp( parent );
	}
}

class EntityInfoTextComp extends Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC = 
		<entity-info-text-comp class="hud-container">
			<text public id="label"/>
		</entity-info-text-comp>

	// @formatter:on
	public function new(
		?parent : Object
	) {
		super( parent );
		initComponent();
	}
}
