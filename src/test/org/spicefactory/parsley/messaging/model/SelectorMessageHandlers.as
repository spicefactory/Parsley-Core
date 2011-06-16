package org.spicefactory.parsley.messaging.model {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.messaging.messages.TestEvent;
import org.spicefactory.parsley.messaging.messages.TestMessage;

import flash.geom.Rectangle;

/**
 * @author Jens Halm
 */
public class SelectorMessageHandlers {

	
	private var _test1Count:int = 0;
	private var _test2Count:int = 0;
	
	private var _sum:int = 0;
	
	private var _dateSelector:Date;
	private var _rectSelector:Rectangle;
	
	
	public function get test1Count () : int {
		return _test1Count;
	}
	
	public function get test2Count () : int {
		return _test2Count;
	}
	
	public function get sum ():int {
		return _sum;
	}
	
	public function get dateSelector () : Date {
		return _dateSelector;
	}
	
	public function get rectSelector () : Rectangle {
		return _rectSelector;
	}
	

	public function allTestMessages (message:TestMessage) : void {
		if (message.name == TestEvent.TEST1) {
			_test1Count++;
		}
		else if (message.name == TestEvent.TEST2) {
			_test2Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + message.name);
		}
		_sum += message.value;
	}

	public function event1 (message:TestMessage, selector:Date) : void {
		if (message.name == TestEvent.TEST1) {
			_test1Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + message.name);
		}
		_sum += message.value;
		_dateSelector = selector;
	}
	
	public function event2 (message:TestMessage, selector:Rectangle) : void {
		if (message.name == TestEvent.TEST2) {
			_test2Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + message.name);
		}
		_sum += message.value;
		_rectSelector = selector;
	}
	

}
}
