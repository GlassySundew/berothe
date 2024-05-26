package game.server.level.block.prefab;

import hrt.prefab.Object3D;
import hrt.prefab.Prefab;
import net.NetNode;
import game.server.level.block.Block;
import game.server.level.prefab.mediator.IPrefabObject;
import game.server.level.prefab.mediator.PrefabObjectMediator;

abstract class Prefab3DObject extends Block implements IPrefabObject {

	@:s public var scaleX : Float;
	@:s public var scaleY : Float;
	@:s public var scaleZ : Float;

	@:s public var rotationX : Float;
	@:s public var rotationY : Float;
	@:s public var rotationZ : Float;

	@:s public var isVisible : Bool;

	var mediator : PrefabObjectMediator;
	var prefab : Object3D;

	public function new( mediator : PrefabObjectMediator, ?parent : NetNode ) {
		super( parent );
		this.mediator = mediator;
		prefab = Std.downcast(mediator.prefab, Object3D);
	}

	public function initPrefab() {
		createPhysics();
		mediator.level.networkLevel.globalBlocks.addBlock( this );
	}
}
