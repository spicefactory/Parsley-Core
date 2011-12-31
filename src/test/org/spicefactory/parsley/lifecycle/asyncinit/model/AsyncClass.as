package org.spicefactory.parsley.lifecycle.asyncinit.model {

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.TimerEvent;
import flash.utils.Timer;

/**
 * @author Jens Halm
 */
public class AsyncClass extends EventDispatcher {


	private var timer: Timer;
	private var order: String;


	public function AsyncClass (order: String) {
		this.order = order;
	}


	[Inject]
	public var recorder: InitSequenceRecorder;


	[Init]
	public function init (): void {
		recorder.addValue("" + order + "C");
		timer = new Timer(10, 1);
		timer.addEventListener(TimerEvent.TIMER, complete);
		timer.start();
	}

	private function complete (event: Event): void {
		recorder.addValue("" + order + "R");
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	
}
}