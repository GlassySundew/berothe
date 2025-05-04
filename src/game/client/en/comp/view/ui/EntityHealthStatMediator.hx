package game.client.en.comp.view.ui;

import Types.Number;
import core.IProperty;
import core.MutableProperty;
import h2d.Flow;
import h2d.Object;
import util.Assets;
import util.GameUtil;

class EntityHealthStatMediator {

	public static final MAX_HP_POSSIBLE = 100;

	final propertyStat : IProperty<Number>;
	final propertyBg : IProperty<Number>;

	public final view : EntityHealthStatViewMediator;

	public function new(
		propertyStat : IProperty<Number>,
		propertyBg : IProperty<Number>,
		parent : Object
	) {
		this.propertyStat = propertyStat;
		this.propertyBg = propertyBg;
		view = new EntityHealthStatViewMediator( this, parent );

		propertyStat.addOnValueImmediately( ( oldVal, val ) -> setStatVal( val ) );
		propertyBg.addOnValueImmediately( ( oldVal, val ) -> setBgVal( val ) );
	}

	public inline function dispose() {
		view.dispose();
	}

	public function setStatVal( val : Float ) {
		view.comp.statAmount.text = '$val';
		var val = util.MathUtil.compressScale( val, 200, 8 );
		view.comp.statComp.statVal = Std.int( val );
	}

	public function setBgVal( val : Float ) {
		var val = util.MathUtil.compressScale( val, 200, 8 );
		view.comp.statComp.bgVal = Std.int( val );
	}
}

class EntityHealthStatViewMediator {

	final mediator : EntityHealthStatMediator;

	public var comp : EntityHpStatComp;

	public function new( mediator : EntityHealthStatMediator, parent : Object ) {
		this.mediator = mediator;
		comp = new EntityHpStatComp( parent );
	}

	public inline function dispose() {
		comp.remove();
	}
}

class EntityHpStatComp extends Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC =
		<entity-hp-stat-comp 
			class="hud-container"
		>
			<stat-bar-comp(util.Assets.healthBarStat) 
				public id="statComp" 
				align = "middle left"
			/>
			<bitmap src={heartIcon}/>
			<text public id = "statAmount" class="numberStat" />
		</entity-hp-stat-comp>

	// @formatter:on
	final heartIcon : h2d.Tile;

	public function new( ?parent ) {
		heartIcon = util.Assets.ui.getTile( Assets.uiAseDict.health_icon );
		super( parent );
		initComponent();
	}
}
