package en.comp.net;

import dn.M;
import h3d.Vector;

class EntityNoBodyComponent extends EntityNetComponent implements IEntityPositionProvider {

	var frict = 0.65;
	public var bumpReduction = 0.;

	var velX_local = .0;
	public var velX( get, set ) : Float;
	inline function get_velX() : Float {
		return velX_local;
	}
	inline function set_velX( v : Float ) : Float {
		return velX_local = v;
	}

	var velY_local = .0;
	public var velY( get, set ) : Float;
	inline function get_velY() : Float {
		return velY_local;
	}
	inline function set_velY( v : Float ) : Float {
		return velY_local = v;
	}

	var velZ_local = .0;
	public var velZ( get, set ) : Float;
	inline function get_velZ() : Float {
		return velZ_local;
	}
	inline function set_velZ( v : Float ) : Float {
		return velZ_local = v;
	}

	public var x : Float = 0;
	public var y : Float = 0;
	public var z : Float = 0;

	var dynamicsComponent : EntityDynamicsComponent;

	public function new( entity : Entity, ?parent ) {
		super( entity, parent );
	}

	override function init() {
		super.init();

		entity.components.onAppear(
			EntityDynamicsComponent,
			( key, dynamicsComponent ) -> {
				this.dynamicsComponent = dynamicsComponent;
				dynamicsComponent.entityPositionProvider.trigger( this );
				x = entity.x;
				y = entity.y;
				z = entity.z;
			}
		);
	}

	public function getEntityPosition() : Vector {
		return new Vector( x, y, z );
	}

	public function update() {
		var stepX = velX * entity.tmod;
		entity.x.val += stepX;
		var stepY = velY * entity.tmod;
		entity.y.val += stepY;
		var stepZ = velZ * entity.tmod;
		entity.z.val += stepZ;

		velX_local *= Math.pow( frict, entity.tmod );
		velY_local *= Math.pow( frict, entity.tmod );
	}
}
