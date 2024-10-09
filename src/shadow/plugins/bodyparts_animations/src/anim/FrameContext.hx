package plugins.bodyparts_animations.src.anim;

import rx.disposables.Assignable;
import rx.Observable;
import game.data.storage.entity.model.EntityEquipmentSlotType;
import hrt.prefab.Prefab;
import signals.Signal;
import game.data.location.DataSheetIdent;
import haxe.exceptions.NotImplementedException;

/**
	created per equip-type
**/
typedef MountPointDispatcher = {
	var signal : Signal<Prefab>;
	var observable : Observable<Prefab>;
}

/**
	Animation manager provides FrameContext to every animation, each one 
	dispatches frame playing event (if frame prefab has cdb entry in it)
	through context, then the game gets `FrameContext` from manager and 
	subscribes to signal
**/
class FrameContext {

	final mountpoints : Map<EntityEquipmentSlotType, MountPointDispatcher> = [];

	public function new() {}

	public function submitDataFrame( prefab : Prefab ) {
		var cdbSheetId : DataSheetIdent = Std.string(
			Reflect.field( prefab.props, util.Const.cdbTypeIdent )
		);

		switch cdbSheetId {
			case PLST_SPECIAL_OBJ:
				var plstCtrl : Data.PlstSpecialObjDFDef = prefab.props;
				var enumType = plstCtrl.type[0];

				var plstEnum = Type.createEnumIndex(
					Data.PLSTSpecialType,
					enumType,
					[for ( i in 1...plstCtrl.type.length ) plstCtrl.type[i]]
				);
				switch plstEnum {
					case Mountpoint( equip ):
						var slotType = EntityEquipmentSlotType.fromCdb( equip );
						var mpObservable = //
							mountpoints[slotType] ?? ( mountpoints[slotType] = createObservable() );

						mpObservable.signal.dispatch( prefab );
				}

			case e:
				throw new NotImplementedException( '$e' );
		}
	}

	public function listenMountpoint(
		equipType : EntityEquipmentSlotType,
		cb : ( Prefab ) -> Void
	) {
		var mpObservable = //
			mountpoints[equipType] ?? ( mountpoints[equipType] = createObservable() );
		mpObservable.observable.observe( cb );
	}

	inline function createObservable() : MountPointDispatcher {
		var signal = new Signal<Prefab>();
		var last = null;
		signal.add( ( ele ) -> last = ele );
		var observable = Observable.create( ( observer ) -> {
			if ( last != null ) observer.on_next( last );
			return new Assignable(
				signal.add( ele -> observer.on_next( ele ) )
			);
		} );
		return {
			signal : signal,
			observable : observable
		}
	}
}
