package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.util.MessageCounter;

/**
 * @author Jens Halm
 */
public class ErrorHandlers extends MessageCounter {

	
	public function allTestEvents (error:Error, processor:MessageProcessor) : void {
		addMessage(processor.message.instance);
	}
	
	public function allEvents (error:Error, processor:MessageProcessor) : void {
		addMessage(processor.message.instance);
	}
	
	public function event1 (error:ContextError, processor:MessageProcessor) : void {
		addMessage(processor.message.instance, "test1");
	}
	
	public function event2 (error:ContextError, processor:MessageProcessor) : void {
		addMessage(processor.message.instance, "test2");
	}
	

}
}
