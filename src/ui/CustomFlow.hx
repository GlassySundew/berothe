package ui;

import signals.Signal;
import util.GameUtil;
import h2d.RenderContext;
import h2d.Flow;

@:uiNoComponent()
class CustomFlow extends Flow {

	public var customFillWidth = false;
	public var customFillHeight = false;

	public final onRemoveSignal = new Signal();

	override function sync( ctx : RenderContext ) {
		if ( customFillWidth && minWidth != GameUtil.wScaled )
			minWidth = GameUtil.wScaled;
		if ( customFillHeight && minHeight != GameUtil.hScaled )
			minHeight = GameUtil.hScaled;

		super.sync( ctx );
	}

	override function onRemove() {
		super.onRemove();
		onRemoveSignal.dispatch();
	}
}

final class CustomFlowComponent extends CustomFlow implements h2d.domkit.Object {

	public function new( ?parent ) {
		super( parent );
		initComponent();
	}
}
