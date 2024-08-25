package ui;

import graphics.ThreeDObjectNode;
import ui.tooltip.TooltipBaseVO;

class InteractorVO {

	public var doHighlight : Bool = false;
	public var highlightColor : Int;
	public var tooltipVO : TooltipBaseVO;
	public var handCursor : Bool = true;

	public function new() {}
}

class InteractorFactory {

	public static inline function create(
		interactorVO : InteractorVO,
		graphics : ThreeDObjectNode
	) {
		// trace( Type.getClass( graphics.heapsObject ) ); //  h3d.scene.$Object

		switch ( Type.getClass( graphics.heapsObject ) ) {}
	}
}
