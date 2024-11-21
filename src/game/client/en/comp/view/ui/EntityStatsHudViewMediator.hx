package game.client.en.comp.view.ui;

import h2d.Flow;
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
		
		mediator.onDefenceChanged.add( ( str ) -> {
			comp.defence_tf.text = str;
		} );
		
		mediator.onGoldChanged.add( ( str ) -> {
			comp.gold_tf.text = str;
		} );		
	}
}

class EntityStatsHudComp extends Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC = 
		<entity-stats-hud-comp halign="right">
			<flow margin="10" hspacing="20" valign="top">
				<shadowed-text() 
					public id="attack_tf" 
				/>
				<shadowed-text() 
					public id="defence_tf" 
				/>
				<shadowed-text() 
					public id="gold_tf" 
				/>				
			</flow>

		</entity-stats-hud-comp>
		
	// @formatter:on
	public function new(
		?parent : Object
	) {
		super( parent );
		initComponent();
		// customFillHeight = true;
	}
}
