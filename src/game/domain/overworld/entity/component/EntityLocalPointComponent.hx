package game.domain.overworld.entity.component;

import rx.disposables.ISubscription;
import game.domain.overworld.location.physics.Types.ThreeDeeVector;
import h3d.Matrix;
import h3d.Vector;
import game.data.storage.entity.body.properties.LocalDispatchPointDescription;

class EntityLocalPointComponent extends EntityComponent {

	var desc( get, never ) : LocalDispatchPointDescription;
	inline function get_desc() : LocalDispatchPointDescription {
		return Std.downcast( description, LocalDispatchPointDescription );
	}

	override function attachToEntity( entity : OverworldEntity ) {
		super.attachToEntity( entity );

		var sub : ISubscription = null;
		sub = entity.location.addOnValueImmediately( ( oldLoc, newLoc ) -> {
			if ( newLoc == null ) return;
			var localPoint = new Vector( desc.offsetX, desc.offsetY, desc.offsetZ );

			var transform = new Matrix();
			transform.identity();
			transform.prependTranslation( entity.transform.x.val, entity.transform.y.val, entity.transform.z.val );
			transform.prependRotation( entity.transform.rotationX, entity.transform.rotationY, entity.transform.rotationZ );

			var globalPoint = util.MatrixUtil.multVector( transform, localPoint );

			newLoc.localPoints.providePoint( desc.name, entity, globalPoint );

			sub.unsubscribe();
		} );
	}
}
