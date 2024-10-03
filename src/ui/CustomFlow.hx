package ui;

import util.GameUtil;
import h2d.RenderContext;
import h2d.Flow;

class CustomFlow extends Flow {

	public var customFillWidth = false;
	public var customFillHeight = false;

	override function sync( ctx : RenderContext ) {
		super.sync( ctx );

		if ( customFillWidth && minWidth != GameUtil.wScaled )
			minWidth = GameUtil.wScaled;
		if ( customFillHeight && minHeight != GameUtil.hScaled )
			minHeight = GameUtil.hScaled;
	}
}
