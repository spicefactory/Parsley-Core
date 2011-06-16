package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.messaging.messages.TestEvent;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class MessageHandlersMetadata extends MessageHandlers {
	
	
	[MessageHandler(order="3")]
	public override function allTestEvents (event:TestEvent) : void {
		super.allTestEvents(event);
	}
	
	[MessageHandler(order="2")]
	public override function allEvents (event:Event) : void {
		super.allEvents(event);
	}
	
	[MessageHandler(selector="test1", order="1")]
	public override function event1 (event:TestEvent) : void {
		super.event1(event);
	}
	
	[MessageHandler(selector="test2", order="1")]
	public override function event2 (event:TestEvent) : void {
		super.event2(event);
	}
	
	[MessageHandler(messageProperties="stringProp,intProp",type="org.spicefactory.parsley.messaging.messages.TestEvent")]
	public override function mappedProperties (stringProp:String, intProp:int) : void {
		super.mappedProperties(stringProp, intProp);
	}

	
}
}
