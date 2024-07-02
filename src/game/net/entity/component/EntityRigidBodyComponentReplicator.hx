package game.net.entity.component;

import game.core.rules.overworld.entity.OverworldEntity;
import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.DataStorage;
import game.core.rules.overworld.entity.component.EntityRigidBodyComponent;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.location.Location;
import game.net.client.GameClient;

class EntityRigidBodyComponentReplicator extends EntityComponentReplicator {

	var rigidBodyComponent : EntityRigidBodyComponent;

	override function alive() {
		super.alive();

		GameClient.inst.currentLocation.onAppear(
			location -> {
				followedComponent.then(
					( _ ) -> onLocationAppearedClient( location )
				);
			}
		);
	}

	override public function followComponentServer( component : EntityComponent ) {
		super.followComponentServer( component );
		rigidBodyComponent = Std.downcast( component, EntityRigidBodyComponent );
	}

	function onLocationAppearedClient( location : Location ) {
		var rigidBodyProp = DataStorage.inst.entityPropertiesStorage.getDescriptionById( componentDescId );
		var rigidBodyDescription = Std.downcast( rigidBodyProp, RigidBodyTorsoDescription );
		rigidBodyComponent = new EntityRigidBodyComponent( rigidBodyDescription );
	}
}
