package game.net.entity.component;

import game.data.storage.entity.body.properties.RigidBodyTorsoDescription;
import game.data.storage.DataStorage;
import game.core.rules.overworld.entity.component.EntityRigidBodyComponent;
import game.core.rules.overworld.entity.EntityComponent;
import game.core.rules.overworld.location.Location;
import game.client.GameClient;

class EntityRigidBodyComponentReplicator extends EntityComponentReplicator {

	@:s var compDescriptionId : String;

	var rigidBodyComponent : EntityRigidBodyComponent;

	override public function followComponentServer( component : EntityComponent ) {
		super.followComponentServer( component );
		rigidBodyComponent = Std.downcast( component, EntityRigidBodyComponent );
		compDescriptionId = rigidBodyComponent.description.id;
	}

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

	function onLocationAppearedClient( location : Location ) {
		var rigidBodyProp = DataStorage.inst.entityPropertiesStorage.getDescriptionById( compDescriptionId );
		var rigidBodyDescription = Std.downcast( rigidBodyProp, RigidBodyTorsoDescription );
		rigidBodyComponent = new EntityRigidBodyComponent( rigidBodyDescription );
	}
}
