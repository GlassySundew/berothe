package game.client.en.comp.view.ui;

import h2d.Object;
import ui.CustomFlow;
import ui.domkit.element.ShadowedTextComp;

class EntityStatsHudViewMediator {

	public final comp : EntityStatsHudComp;
	final mediator : EntityStatsHudMediator;

	public function new(
		mediator : EntityStatsHudMediator,
		?parent : Object
	) {
		this.mediator = mediator;
		comp = new EntityStatsHudComp( parent );

		mediator.onAttackChanged.add( ( str ) -> {
			comp.attack_tf.text = str;
		} );
	}
}

class EntityStatsHudComp extends CustomFlow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC = 
		<entity-stats-hud-comp fill-width="true" >
			<flow margin="10">
				<shadowed-text() 
					public id="attack_tf" 
					valign="bottom"
				/>
			</flow>

		</entity-stats-hud-comp>
		
	// @formatter:on
	public function new(
		?parent : Object
	) {
		super( parent );
		initComponent();
		customFillHeight = true;
	}
}
