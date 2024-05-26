// package game.server.level.prefab.adapter;

// import game.server.level.block.prefab.PrefabBox;
// import plugins.prefab_berothe.src.customObj.CustomBox;

// class PrefabBoxAdapter extends Prefab3DObjectAdapter<PrefabBox> {

// 	public function new( mediator ) {
// 		super( mediator );
// 	}

// 	override function createObject() : PrefabBox {
// 		if ( object == null ) object = new PrefabBox( mediator );
// 		var prefab = Std.downcast( mediator.prefab, CustomBox );
// 		object.isCollidable = prefab.isCollidable;

// 		super.createObject();
		
// 		return object;
// 	}
// }
