// package game.server.level;

// import hrt.prefab.ContextShared;
// import hrt.prefab.Prefab;
// import hrt.prefab.Reference;
// import hxd.Res;
// import game.server.level.prefab.PrefabInstanceResolver;
// import game.server.level.prefab.adapter.PrefabBoxAdapter;
// import game.server.level.prefab.mediator.PrefabObjectMediator;

// enum abstract PrefabObjectIdent( String ) from String {

// 	var CUSTOM_BOX = "customBox";
// 	var COLLISION = "collisionbox";
// 	var INSTANCE = "instance";
// }

// class PrefabObjectsProvider implements ILevelObjectsProvider {

// 	var ctxShared = new ContextShared();
// 	var prefab : hrt.prefab.Prefab;
// 	var level : ServerLevelController;

// 	public function new( filePath : String ) {
// 		prefab = Res.load( filePath ).toPrefab().load();
// 	}

// 	public function init( level : ServerLevelController ) : Void {
// 		this.level = level;

// 		derefPrefabRecursive( prefab );
// 		makePrefabRecursive( prefab );
// 	}

// 	function derefPrefabRecursive( prefab : Prefab ) {
// 		for ( i => child in prefab.children ) {
// 			derefPrefabRecursive( child );
// 			if ( Std.is ( child, Reference ) ) {
// 				prefab.children[i] = Std.downcast( child, Reference ).resolveRef( ctxShared );
// 				derefPrefabRecursive( prefab.children[i] );
// 			}
// 		}
// 	}

// 	function makePrefabRecursive( prefab : Prefab ) {
// 		for ( child in prefab.children ) {
// 			var mediator = new PrefabObjectMediator( child, level );

// 			switch( child.type : PrefabObjectIdent ) {
// 				case CUSTOM_BOX:
// 					new PrefabBoxAdapter( mediator );
// 				// case Collision.type:
// 				// new PrefabCollsi
// 				case INSTANCE:
// 					new PrefabInstanceResolver( mediator );
// 				default:
// 					trace( "Object " + child.type + " was not found supported while parsing" );
// 					continue;
// 			}

// 			makePrefabRecursive( child );
// 		}
// 	}
// }
