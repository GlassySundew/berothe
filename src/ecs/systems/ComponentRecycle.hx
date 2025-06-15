package ecs.systems;

import echoes.ComponentStorage;
import echoes.View.DynamicView;
import echoes.View.ViewBase;
import echoes.Entity;
import echoes.System;
import game.domain.SystemPriority;

@:priority( SystemPriority.DISPOSAL )
class ComponentRecycle extends System {

	final storage : ComponentStorage<Dynamic>;
	final view : ViewBase;

	public function new(
		storage : ComponentStorage<Dynamic>,
		view : ViewBase,
		world,
		?p
	) {
		super( world, p );

		this.storage = storage;
		this.view = view;

		#if debug performRelativenessCheck(); #end
	}

	function performRelativenessCheck() {

		if ( !storage.relatedViews.contains( view ) )
			throw "filtering view does not belong to the storage provided!";
	}

	@:upd
	#if !debug inline #end
	function update() : Void {

		view.iterUntyped( ( entity, componenets ) -> {
			storage.remove( entity, world );
		} );
	}
}
