package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.util.MessageCounter;

/**
 * @author Jens Halm
 */
public class ErrorHandlers extends MessageCounter {

	
	public function allTestEvents (processor:MessageProcessor, error:Error) : void {
		addMessage(processor.message);
	}
	
	public function allEvents (processor:MessageProcessor, error:Error) : void {
		addMessage(processor.message);
	}
	
	public function event1 (processor:MessageProcessor, error:ContextError) : void {
		addMessage(processor.message, "test1");
	}
	
	public function event2 (processor:MessageProcessor, error:ContextError) : void {
		addMessage(processor.message, "test2");
	}
	

}
}
