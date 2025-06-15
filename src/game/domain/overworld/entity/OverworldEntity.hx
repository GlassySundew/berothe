package game.domain.overworld.entity;

import dn.Cooldown;
import game.domain.overworld.entity.component.model.EntityModelComponent;
import dn.Delayer;
import util.Assert;
import future.Future;
import game.domain.overworld.entity.component.EntityRigidBodyComponent;
import game.domain.overworld.location.OverworldLocationMain;
import core.IProperty;
import core.MutableProperty;
import signals.Signal;
import game.domain.overworld.entity.EntityComponents;
import game.domain.overworld.location.Chunk;
import game.data.storage.entity.EntityDescription;

class OverworldEntity {

	public final id : String;
	public final desc : EntityDescription;
	public final transform : EntityTransform = new EntityTransform();
	public final components : EntityComponents;
	public final delayer = new Delayer( hxd.Timer.wantedFPS );
	public final cd = new Cooldown( hxd.Timer.wantedFPS );
	public final disposed : Future<Bool> = new Future();
	public final postDisposed : Future<Bool> = new Future();

	public var onFrame( default, null ) : Signal<Float, Float> = new Signal<Float, Float>();

	var disposeInvalidate = false;

	var chunkSelf : MutableProperty<Chunk> = new MutableProperty<Chunk>();
	public var chunk( get, never ) : IProperty<Chunk>;
	inline function get_chunk() : IProperty<Chunk> {
		return chunkSelf;
	}

	var locationSelf : MutableProperty<OverworldLocationMain> = new MutableProperty<OverworldLocationMain>();
	public var location( get, never ) : IProperty<OverworldLocationMain>;
	inline function get_location() : IProperty<OverworldLocationMain> {
		return locationSelf;
	}

	public function new( entityDesc : EntityDescription, id : String ) {
		this.desc = entityDesc;
		components = new EntityComponents( this );
		this.id = id;
	}

	public function dispose() {
		Assert.isFalse( disposed.isTriggered, this + " entity double dispose" );
		disposed.resolve( true );
		components.dispose();
		postDisposed.resolve( true );
		delayer.destroy();
		cd.destroy();

		onFrame.destroy();
		onFrame = null;
	}

	public function invalidateDispose() {
		disposeInvalidate = true;
	}

	#if !debug inline #end
	public function update( dt : Float, tmod : Float ) {
		onFrame.dispatch( dt, tmod );
		delayer.update( tmod );
		cd.update( tmod );
		
		if ( disposeInvalidate ) dispose();
	}

	public function setLocation( location : OverworldLocationMain ) {
		locationSelf.val = location;
	}

	public function addToChunk( chunk : Chunk ) {
		chunkSelf.val = chunk;
	}

	public function removeChunk() {
		chunkSelf.val = null;
	}

	@:keep
	public function toString() : String {
		var model = components.get( EntityModelComponent );
		return "Entity: " + desc.id + " " + ( model != null ? model.displayName.val : "" );
	}
}
