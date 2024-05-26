// package en.comp.client.view;

// import dn.M;
// import dn.MacroTools;
// import h3d.scene.Mesh;
// import hrt.prefab.Prefab.ContextMake;
// import hrt.prefab.Prefab;
// import hxd.Res;
// import plugins.bodyparts_animations.src.INeedPrefabContext;
// import plugins.bodyparts_animations.src.anim.FBFAnimator;
// import plugins.bodyparts_animations.src.customObj.Bodypart;
// import plugins.bodyparts_animations.src.customObj.EntityComposer;
// import plugins.bodyparts_animations.src.customObj.FBFAnimationNode;
// import signals.Signal0;
// import en.comp.client.EntityViewComponent.AnimationKey;
// import en.comp.net.EntityDynamicsComponent;

// class EntityComposerView implements IEntityView {

// 	final animationsByKey : Map<AnimationKey, Array<String>> = [];
// 	final entityComposerPrefab : EntityComposer;
// 	final modelObject : h3d.scene.Object;
// 	final viewCdb : Data.Entity_view;
// 	final entity : Entity;

// 	var meshes : Array<Mesh>;
// 	var currentlyPlaying : Array<FBFAnimator> = [];

// 	public function new( entity : Entity, viewCdb : Data.Entity_view, fileView : String ) {
// 		this.viewCdb = viewCdb;
// 		this.entity = entity;
		
// 		entityComposerPrefab = Std.downcast( hxd.Res.load( fileView ).toPrefab().load(), EntityComposer );
// 		modelObject = entityComposerPrefab.local3d;
// 		Boot.inst.s3d.addChild( entityComposerPrefab.local3d );

// 		setupMeshMaterials();
// 		setupAnimationKeys();
// 		provideSceneTools();

// 		entity.components.onAppear(
// 			EntityDynamicsComponent,
// 			( key, dynamics ) -> {
// 				dynamics.onMove.add(() -> {
// 					var entityPos = dynamics.entityPositionProvider.toResult();
// 					if ( !entity.model.isMovementApplied ) return;
// 					modelObject.setRotation(
// 						0,
// 						0,
// 						Math.atan2( entityPos.velY, entityPos.velX ) + M.toRad( 90 )
// 					);
// 				} );
// 			}
// 		);
// 	}

// 	public function getSceneObject() {
// 		return modelObject;
// 	}

// 	public function setPosition( x : Float, y : Float, z : Float ) {
// 		modelObject.x = x;
// 		modelObject.y = y;
// 		modelObject.z = z;
// 	}

// 	function provideSceneTools() {
// 		util.HideUtil.mapPrefabWithDeref( entityComposerPrefab, ( prefab ) -> {
// 			if ( Std.isOfType( prefab, INeedPrefabContext ) ) {
// 				var providee = cast( prefab, INeedPrefabContext );
// 				var scenePrefab = modelObject.getObjectByName( prefab.name );

// 				// TODO providee.context = modelObject;

// 				// providee.getObjByName = modelContext.local3d.getObjectByName;
// 				// providee.setVisibility = ( prefabsToChangeVisibility : Array<Prefab>, value : Bool ) -> {
// 				// 	for ( prefabToChangeVisibility in prefabsToChangeVisibility ) {
// 				// 		scenePrefab.getObjectByName( prefabToChangeVisibility.name ).visible = value;
// 				// 	}
// 			}

// 			if ( Std.isOfType( prefab, FBFAnimationNode ) ) {
// 				var fbfNode = Std.downcast( prefab, FBFAnimationNode );
// 				fbfNode.onChildrenChangedSignal.dispatch();
// 				entity.onFrame.add(() -> {
// 					fbfNode.sync( Boot.inst.deltaTime );
// 				} );
// 			}
// 			if ( Std.isOfType( prefab, Bodypart ) ) {
// 				Std.downcast( prefab, Bodypart ).onChildListChanged();
// 			}
// 		});
// 	}

// 	function setupMeshMaterials() {
// 		if ( meshes == null )
// 			meshes = modelObject.getMeshes();
// 		for ( mesh in meshes ) {
// 			mesh.material.texture.filter = Nearest;
// 		}
// 	}

// 	public function playAnimation( animationKey : AnimationKey, ?overrideSpeed : Null<Float> ) {
// 		for ( animation in animationsByKey[animationKey] ) {
// 			var animationContainer = entityComposerPrefab.animationManager.animationGroups[animation];
// 			animationContainer.setPlay( true );
// 			if ( overrideSpeed != null )
// 				animationContainer.overrideSpeed( overrideSpeed );
// 			else
// 				animationContainer.unOverrideSpeed();
// 		}
// 	}

// 	function setupAnimationKeys() {
// 		for ( key in MacroTools.getAbstractEnumValues( AnimationKey ) ) {
// 			var animationKeys : Array<{animationName : String }> = Reflect.field( viewCdb.animations, key.value );
// 			if ( animationsByKey[key.value] == null )
// 				animationsByKey[key.value] = [];
// 			for ( animationKey in animationKeys ) {
// 				animationsByKey[key.value].push( animationKey.animationName );
// 			}
// 		}
// 	}
// }
