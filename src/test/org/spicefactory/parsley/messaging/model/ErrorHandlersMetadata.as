package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * @author Jens Halm
 */
public class ErrorHandlersMetadata extends ErrorHandlers {

	
	[MessageError(type="org.spicefactory.parsley.messaging.messages.TestEvent")]
	public override function allTestEvents (processor:MessageProcessor, error:Error) : void {
		super.allTestEvents(processor, error);
	}
	
	[MessageError]
	public override function allEvents (processor:MessageProcessor, error:Error) : void {
		super.allEvents(processor, error);
	}
	
	[MessageError(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test1")]
	public override function event1 (processor:MessageProcessor, error:ContextError) : void {
		super.event1(processor, error);
	}
	
	[MessageError(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test2")]
	public override function event2 (processor:MessageProcessor, error:ContextError) : void {
		super.event2(processor, error);
	}
	

}
}
