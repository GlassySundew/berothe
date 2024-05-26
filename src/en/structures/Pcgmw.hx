package en.structures;


import util.Assets;

class Pcgmw extends Structure {

	public function new() {
		super();
	}

	override function postUpdate() {
		super.postUpdate();
		// mesh.z += 1 / Camera.ppu;
	}
}
