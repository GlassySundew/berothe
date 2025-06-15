package game.domain.overworld.location;

import game.domain.overworld.entity.OverworldEntity;

interface ILocationContainer {

	function request( requesterUnitID : String, ?auth : Bool ) : OverworldLocationMain;
	function update() : Void;
}
