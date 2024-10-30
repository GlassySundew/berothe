package pass;

class CharacterDepthShader extends h3d.shader.ScreenShader {

	static var SRC = {
		//
		@param var texture : Sampler2D;
		@param var characterPos : Vec3;
		var distanceToCharacter : Float;
		var pixelDepthFromCharacter : Float;
		//
		function fragment() {
			distanceToCharacter = length( output.position.xyz - characterPos.xyz );
			pixelDepthFromCharacter = texture.get( input.uv ).r;

			if ( texture.get( input.uv ).r < distanceToCharacter ) {
				pixelColor = vec4(1);
			} else {
				pixelColor = vec4(0);
			}
		}
	};
}

class CharacterDepth extends h3d.pass.ScreenFx<CharacterDepthShader> {

	public function new() {
		super( new CharacterDepthShader() );
	}

	public function apply( tex : h3d.mat.Texture ) {
		shader.texture = tex;
		render();
	}
}
