package game.client.en.comp.view;

import h3d.Vector;
import hrt.prefab.Object3D;
import graphics.ObjectNode3D;
import h3d.scene.fwd.PointLight;
import util.Assert;
import game.domain.overworld.location.Location;
import game.domain.overworld.entity.OverworldEntity;
import game.data.storage.entity.body.view.EntityLightSourceDescription;
import game.domain.overworld.entity.EntityComponent;

class EntityLightSourceComponent extends EntityComponent {

	final lightSourceDescription : EntityLightSourceDescription;

	public function new( lightSourceDescription : EntityLightSourceDescription ) {
		super( lightSourceDescription );
		this.lightSourceDescription = lightSourceDescription;
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		entity.location.onAppear( onAttachedToLocation );
	}

	function onAttachedToLocation( location : Location ) {

		var parentViewComp = entity.components.get( EntityViewComponent );
		Assert.notNull( parentViewComp );

		var light = new PointLight();
		light.params = new Vector( 10, 10, 0.5 );
		light.enableSpecular = true;

		parentViewComp.addChildObject( ObjectNode3D.fromHeaps( light ) );

		parentViewComp.view.then( ( parentViewResult ) -> {
			var manager = //
				Std.downcast( parentViewResult, EntityComposerView )
					.entityComposer.animationManager;
			trace( "LIGHT SET" );

			manager.context.listenMountpoint(
				lightSourceDescription.equipSource,
				( prefab ) -> {
					var obj = Std.downcast( prefab, Object3D );
					Assert.notNull( obj );
					// light.setPosition(
					// 	obj.x,
					// 	obj.y,
					// 	obj.z
					// );
				} );
		} );
	}
}