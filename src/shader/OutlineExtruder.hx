package shader;

import h3d.Matrix;
import hxsl.Shader;

class OutlineExtruder extends Shader {

	static var SRC = {
		//
		@:import h3d.shader.BaseMesh;
		// @input var input : {
		// 	var position : Vec3;
		// 	var normal : Vec3;
		// };
		@param var radius : Float = 1;
		@param var scaleMat : Mat3;
		// var relativePosition : Vec3;
		//
		var scaleFactor : Float = 3.0;
		function __init__() {
			// var normalDir = normalize(input.normal);
			// var offset = normalDir * 1;
			// transformedPosition += normalize(input.normal);
			// var pos : Vec4 = vec4(input.position, 1.0);
			// pos *= scaleMat;
			// // pos

			// relativePosition *= 2;

			relativePosition += normalize( input.normal ) * 1.1;
			// relativePosition *= 1.1;
		}

		function __init__fragment() {

		}
	}

	public function new() {
		super();
		scaleMat = new Matrix();
		scaleMat.identity();
		scaleMat.scale( 4, 4, 4 );
	}
}
