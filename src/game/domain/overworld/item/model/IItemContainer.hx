package game.domain.overworld.item.model;

import game.data.storage.item.ItemDescription;

interface IItemContainer {

	function hasSpaceForItem( item : ItemDescription, ?amount : Int ) : Bool;
	function giveItem( item : Item ) : Void;
}
