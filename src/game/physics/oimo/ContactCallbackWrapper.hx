package game.physics.oimo;

import signals.Signal;
import oimo.dynamics.Contact;
import oimo.dynamics.callback.ContactCallback;

class ContactCallbackWrapper extends ContactCallback {

	public final beginCB : Signal<Contact> = new Signal<Contact>();
	public final preSolveCB : Signal<Contact> = new Signal<Contact>();
	public final postSolveCB : Signal<Contact> = new Signal<Contact>();
	public final endContactCB : Signal<Contact> = new Signal<Contact>();

	override public function beginContact( c : Contact ) : Void {
		beginCB.dispatch( c );
	}

	override public function preSolve( c : Contact ) : Void {
		preSolveCB.dispatch( c );
	}

	override public function postSolve( c : Contact ) : Void {
		postSolveCB.dispatch( c );
	}

	override public function endContact( c : Contact ) : Void {
		endContactCB.dispatch( c );
	}
}
