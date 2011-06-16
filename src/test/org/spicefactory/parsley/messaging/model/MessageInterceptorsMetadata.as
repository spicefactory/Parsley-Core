package org.spicefactory.parsley.messaging.model {

import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.messaging.messages.TestEvent;

/**
 * @author Jens Halm
 */
public class MessageInterceptorsMetadata extends MessageInterceptors {

	// TODO - test at least one handler without message param
	
	[MessageHandler(type="org.spicefactory.parsley.messaging.messages.TestEvent", order="-1")]
	public override function interceptAllMessages (message:TestEvent, processor:MessageProcessor) : void {
		super.interceptAllMessages(message, processor);
	}
	
	[MessageHandler(order="-1")]
	public override function allEvents (message:Object, processor:MessageProcessor) : void {
		super.allEvents(message, processor);
	}
	
	[MessageHandler(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test1")]
	public override function event1 (message:TestEvent, processor:MessageProcessor) : void {
		super.event1(message, processor);
	}
	
	[MessageHandler(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test2")]
	public override function event2 (message:TestEvent, processor:MessageProcessor) : void {
		super.event2(message, processor);
	}
	
	
}
}
