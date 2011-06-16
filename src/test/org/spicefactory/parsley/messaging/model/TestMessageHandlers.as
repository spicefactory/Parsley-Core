package org.spicefactory.parsley.messaging.model {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.messaging.messages.TestMessage;
import org.spicefactory.parsley.messaging.messages.TestEvent;

/**
 * @author Jens Halm
 */
public class TestMessageHandlers {

	
	private var _test1Count:int = 0;
	private var _test2Count:int = 0;
	
	private var _sum:int = 0;
	
	
	public function get test1Count () : int {
		return _test1Count;
	}
	
	public function get test2Count () : int {
		return _test2Count;
	}
	
	public function get sum ():int {
		return _sum;
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

	public function event1 (message:TestMessage) : void {
		if (message.name == TestEvent.TEST1) {
			_test1Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + message.name);
		}
		_sum += message.value;
	}
	
	public function event2 (message:TestMessage) : void {
		if (message.name == TestEvent.TEST2) {
			_test2Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + message.name);
		}
		_sum += message.value;
	}
	

}
}
