package en.collide;

import signals.Signal;
import signals.Signal1;
import oimo.dynamics.Contact;
import oimo.dynamics.callback.ContactCallback;

class EntityContactCallback extends ContactCallback {

	public var beginContactSign = new Signal1<Contact>();
	public var preSolveSign = new Signal1<Contact>();
	public var postSolveSign = new Signal1<Contact>();
	public var endContactSign = new Signal1<Contact>();

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
