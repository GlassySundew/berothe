package game.server.level.prefab;

import game.server.level.prefab.mediator.IPrefabObject;
import game.server.level.spawn.EntitySpawnPoint;
import hrt.prefab.l3d.Instance;
import game.server.level.prefab.adapter.PrefabAdapter;
import game.server.level.prefab.mediator.PrefabObjectMediator;

enum abstract DataSheetIdent( String ) from String {

	var ENTITY_SPAWNPOINT = "entitySpawnPointDF";
}

class PrefabInstanceResolver extends PrefabAdapter<EntitySpawnPoint> {

	// static final instanceObjectMap : Map<>();
	var instance : Instance;

	public function new( mediator : PrefabObjectMediator ) {
		this.mediator = mediator;
		this.instance = Std.downcast( mediator.prefab, Instance );
		super( mediator );
	}

	function createObject() : EntitySpawnPoint {
		var cdbSheetId : DataSheetIdent = Std.string( Reflect.field( instance.props, "$cdbtype" ) );

		return
			switch cdbSheetId {
				case ENTITY_SPAWNPOINT:
					var entry : Data.EntitySpawnPointDFDef = instance.props;
					new EntitySpawnPoint( mediator, Data.entityBody.get( entry.entity ) );
			}
	}

	function adaptObject() {}
}
