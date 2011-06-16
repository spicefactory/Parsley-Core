package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.messaging.messages.TestMessage;

import flash.geom.Rectangle;

/**
 * @author Jens Halm
 */
public class SelectorMessageHandlersMetadata extends SelectorMessageHandlers {

	
	[MessageHandler]
	public override function allTestMessages (message:TestMessage) : void {
		super.allTestMessages(message);
	}

	[MessageHandler]
	public override function event1 (message:TestMessage, selector:Date) : void {
		super.event1(message, selector);
	}
	
	[MessageHandler]
	public override function event2 (message:TestMessage, selector:Rectangle) : void {
		super.event2(message, selector);
	}
	

}
}
