package en.collide;

import signals.Signal;
import signals.Signal;
import oimo.dynamics.Contact;
import oimo.dynamics.callback.ContactCallback;

class EntityContactCallback extends ContactCallback {

	public var beginContactSign = new Signal<Contact>();
	public var preSolveSign = new Signal<Contact>();
	public var postSolveSign = new Signal<Contact>();
	public var endContactSign = new Signal<Contact>();

	override function beginContact( c : Contact ) {
		beginContactSign.dispatch( c );
	}

	override function preSolve( c : Contact ) {
		preSolveSign.dispatch( c );
	}

	override function postSolve( c : Contact ) {
		postSolveSign.dispatch( c );
	}

	override function endContact( c : Contact ) {
		endContactSign.dispatch( c );
	}
}
