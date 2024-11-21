package game.client.en.comp.view.ui;

import Types.Number;
import core.IProperty;
import util.Assets;
import domkit.Object;
import h2d.Flow;
import core.MutableProperty;
import util.GameUtil;

class EntityHealthStatMediator {

	public static final MAX_HP_POSSIBLE = 100;

	final propertyStat : IProperty<Number>;
	final propertyBg : IProperty<Number>;

	public final view : EntityHealthStatViewMediator;

	public function new(
		propertyStat : IProperty<Number>,
		propertyBg : IProperty<Number>
	) {
		this.propertyStat = propertyStat;
		this.propertyBg = propertyBg;
		view = new EntityHealthStatViewMediator( this );

		propertyStat.addOnValueImmediately( ( oldVal, val ) -> {
			setStatVal( val );
		} );

		propertyBg.addOnValueImmediately( ( oldVal, val ) -> {
			setBgVal( val );
		} );
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

	public function new( mediator : EntityHealthStatMediator ) {
		this.mediator = mediator;
		comp = new EntityHpStatComp( Main.inst.topRightHud );
	}

	public inline function dispose() {
		comp.remove();
	}
}

class EntityHpStatComp extends Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC =
		<entity-hp-stat-comp 
			layout="horizontal"
			margin = "5"
			hspacing = "10"
		>
			<stat-bar-comp(util.Assets.healthBarStat) 
				public id="statComp" 
				align = "middle left"
			/>
			<bitmap src={heartIcon}/>
			<shadowed-text() 
				public id = "statAmount"
				align = "middle left"
				offset-y = "-2"
				min-width = "25"
			/>
		</entity-hp-stat-comp>

	// @formatter:on
	final heartIcon : h2d.Tile;

	public function new( ?parent ) {
		heartIcon = util.Assets.ui.getTile( Assets.uiAseDict.health_icon );
		super( parent );
		initComponent();
	}
}
