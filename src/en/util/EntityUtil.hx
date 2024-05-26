package en.util;

import oimo.common.Vec3;
import dn.M;
import game.client.GameClient;
import game.server.GameServer;
import hxGeomAlgo.HxPoint;
import hxGeomAlgo.PoleOfInaccessibility;
import util.TmxUtils;


class EntityUtil {

	public static inline function angTo( ethis : Entity, e : Entity )
		return Math.atan2( e.y.val - ethis.y.val, e.x.val - ethis.x.val );

	public static inline function angToPxFree( ent : Entity, x : Float, y : Float )
		return Math.atan2( y - ent.y.val, x - ent.x.val );

	public static inline function distPx( self : Entity, e : Entity ) {
		return M.dist(
			self.x.val,
			self.y.val,
			e.x.val,
			e.y.val );
	}

	public static inline function distPxFree( self : Entity, x : Float, y : Float ) {
		return M.dist(
			self.x.val,
			self.y.val,
			x,
			y
		);
	}

	/**
		подразумевается, что у этой сущности есть длинный изометрический меш
	**/
	public static function distPolyToPt( self : Entity, e : Entity ) : Float {
		return distPx( self, e );
	}
}
