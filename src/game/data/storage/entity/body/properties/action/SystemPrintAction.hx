package game.data.storage.entity.body.properties.action;

import game.domain.overworld.entity.OverworldEntity;

class SystemPrintAction extends BodyActionBase {

	final localeId : String;

	public function new( localeId : String ) {
		this.localeId = localeId;
	}

	public function perform( self : OverworldEntity, user : OverworldEntity ) {
		#if client
		game.net.client.GameClient.inst.consoleSay(
			Data.locale.resolve( localeId ).text
		);
		#end
	}
}
