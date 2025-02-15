package ui.domkit.element;

import be.Constant.Floats;
import dn.M;
import h2d.Tile;
import util.Assets;
import util.StatAsset;
import h2d.Flow;

@:uiComp( "stat-bar-comp" )
class StatBarComp extends Flow implements h2d.domkit.Object {

	// @formatter:off
	static var SRC =
		<stat-bar-comp>
			<flow layout="horizontal">
				<flow id="bg" />
				<mask id="statValMask" position="absolute">
					<flow id="stat" overflow="hidden">
					</flow>
				</mask>
			</flow>
		</stat-bar-comp>

	// @formatter:on
	public var bgVal( get, set ) : Int;
	inline function get_bgVal() return Std.int( bg.background.width );
	inline function set_bgVal( v : Int ) return Std.int( bg.background.width = v );

	public var statVal( get, set ) : Int;
	inline function get_statVal() return Std.int( stat.background.width );
	inline function set_statVal( v : Int ) {
		statValMask.width = v;
		return Std.int( stat.background.width = M.fclamp( v, stat.background.tile.width, Floats.MAX ) );
	}

	final statCenterWidth : Int;

	public function new( statAsset : StatAsset, ?parent ) {
		super( parent );
		initComponent();

		var statSG = stat.background = Assets.uiAse.toScaleGrid( statAsset.value, 0, stat );
		var bgSG = bg.background = Assets.uiAse.toScaleGrid( statAsset.bg, 0, bg );

		statValMask.height = Std.int( statSG.height );

		statCenterWidth = Std.int( stat.background.tile.width - stat.background.borderRight - stat.background.borderLeft );
	}
}
