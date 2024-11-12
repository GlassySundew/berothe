package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;

interface ILocationContainer {

	function request( requestor : OverworldEntity, ?auth : Bool ) : Location;
	function update( dt : Float, tmod : Float ) : Void;
}
