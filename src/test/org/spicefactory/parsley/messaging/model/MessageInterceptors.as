package org.spicefactory.parsley.messaging.model {
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.messaging.messages.TestEvent;

/**
 * @author Jens Halm
 */
public class MessageInterceptors {

	
	private var _genericEventCount:int = 0;
	private var _test1Count:int = 0;
	private var _test2Count:int = 0;
	
	
	private var _event2Processor:MessageProcessor;
	
	
	public function get test1Count () : int {
		return _test1Count;
	}
	
	public function get test2Count () : int {
		return _test2Count;
	}
	
	public function get genericEventCount ():int {
		return _genericEventCount;
	}
	

	public function interceptAllMessages (processor:MessageProcessor) : void {
		if (processor.message.instance.type == TestEvent.TEST1) {
			_test1Count++;
		}
		else if (processor.message.instance.type == TestEvent.TEST2) {
			_test2Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + processor.message.type);
		}
	}
	
	public function allEvents (processor:MessageProcessor) : void {
		_genericEventCount++;
	}
	
	public function event1 (processor:MessageProcessor) : void {
		if (processor.message.instance.type == TestEvent.TEST1) {
			_test1Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + processor.message.type);
		}
	}
	
	public function event2 (processor:MessageProcessor) : void {
		processor.suspend();
		if (processor.message.instance.type == TestEvent.TEST2) {
			_test2Count++;
		}
		else {
			throw new IllegalArgumentError("Unexpected event type: " + processor.message.type);
		}
		_event2Processor = processor;
	}
	
	public function proceedEvent2 () : void {
		_event2Processor.resume();
	}
	
	
}
}
