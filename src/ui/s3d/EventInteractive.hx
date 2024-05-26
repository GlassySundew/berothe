package ui.s3d;

import signals.*;
import h3d.scene.Interactive;
import hxd.Event;

/**
	Simple wrapper to h3d.scene.Interactive that allows multiple subscriptions to on* events.
	Overriding on* functions still possible.

	ported to 3d from yanrishatum's code
**/
class EventInteractive extends Interactive {
	public var onOverEvent:Signal1<Event> = new Signal1();
	public var onOutEvent:Signal1<Event> = new Signal1();
	public var onPushEvent:Signal1<Event> = new Signal1();
	public var onReleaseEvent:Signal1<Event> = new Signal1();
	public var onReleaseOutsideEvent:Signal1<Event> = new Signal1();
	public var onClickEvent:Signal1<Event> = new Signal1();
	public var onMoveEvent:Signal1<Event> = new Signal1();
	public var onWheelEvent:Signal1<Event> = new Signal1();
	public var onFocusEvent:Signal1<Event> = new Signal1();
	public var onFocusLostEvent:Signal1<Event> = new Signal1();
	public var onKeyUpEvent:Signal1<Event> = new Signal1();
	public var onKeyDownEvent:Signal1<Event> = new Signal1();
	public var onCheckEvent:Signal1<Event> = new Signal1();
	public var onTextInputEvent:Signal1<Event> = new Signal1();

	override public function handleEvent(e:Event) {
		if (propagateEvents)
			e.propagate = true;
		if (cancelEvents)
			e.cancel = true;
		switch (e.kind) {
			case EMove:
				onMoveEvent.dispatch(e);
				onMove(e);
			case EPush:
				if (enableRightButton || e.button == 0) {
					mouseDownButton = e.button;
					onPushEvent.dispatch(e);
					onPush(e);
				}
			case ERelease:
				if (enableRightButton || e.button == 0) {
					onReleaseEvent.dispatch(e);
					onRelease(e);
					if (mouseDownButton == e.button) {
						onClickEvent.dispatch(e);
						onClick(e);
					}
				}
				mouseDownButton = -1;
			case EReleaseOutside:
				if (enableRightButton || e.button == 0) {
					onReleaseEvent.dispatch(e);
					onRelease(e);
					if (mouseDownButton == e.button) {
						onReleaseOutsideEvent.dispatch(e);
						onReleaseOutside(e);
					}
				}
				mouseDownButton = -1;
			case EOver:
				onOverEvent.dispatch(e);
				onOver(e);
				if (!e.cancel && cursor != null)
					hxd.System.setCursor(cursor);
			case EOut:
				mouseDownButton = -1;
				onOutEvent.dispatch(e);
				onOut(e);
				if (!e.cancel)
					hxd.System.setCursor(Default);
			case EWheel:
				onWheelEvent.dispatch(e);
				onWheel(e);
			case EFocusLost:
				onFocusLostEvent.dispatch(e);
				onFocusLost(e);
			case EFocus:
				onFocusEvent.dispatch(e);
				onFocus(e);
			case EKeyUp:
				onKeyUpEvent.dispatch(e);
				onKeyUp(e);
			case EKeyDown:
				onKeyDownEvent.dispatch(e);
				onKeyDown(e);
			case ECheck:
				onCheckEvent.dispatch(e);
				onCheck(e);
			case ETextInput:
				onTextInputEvent.dispatch(e);
				onTextInput(e);
		}
	}
}
