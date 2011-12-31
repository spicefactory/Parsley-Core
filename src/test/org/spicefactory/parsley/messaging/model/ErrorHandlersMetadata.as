package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * @author Jens Halm
 */
public class ErrorHandlersMetadata extends ErrorHandlers {

	
	[MessageError(type="org.spicefactory.parsley.messaging.messages.TestEvent")]
	public override function allTestEvents (error:Error, processor:MessageProcessor) : void {
		super.allTestEvents(error, processor);
	}
	
	[MessageError]
	public override function allEvents (error:Error, processor:MessageProcessor) : void {
		super.allEvents(error, processor);
	}
	
	[MessageError(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test1")]
	public override function event1 (error:ContextError, processor:MessageProcessor) : void {
		super.event1(error, processor);
	}
	
	[MessageError(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test2")]
	public override function event2 (error:ContextError, processor:MessageProcessor) : void {
		super.event2(error, processor);
	}
	

}
}
