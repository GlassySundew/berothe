package en.model;

import hxbit.NetworkSerializable;
import en.player.Player.PlayerActionState;
import net.NSMutableProperty;
import ui.core.InventoryGrid;
import ui.player.ItemCursorHolder;
import net.NetNode;

class PlayerModel implements NetworkSerializable {

	@:s public var nickname = "";
	@:s public var actionState : NSMutableProperty<PlayerActionState> = new NSMutableProperty<PlayerActionState>( Idle );

	public function new() {
		enableAutoReplication = true;
	}
}
