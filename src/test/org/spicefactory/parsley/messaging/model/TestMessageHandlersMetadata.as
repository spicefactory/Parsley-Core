package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.messaging.messages.TestMessage;

/**
 * @author Jens Halm
 */
public class TestMessageHandlersMetadata extends TestMessageHandlers {

	
	[MessageHandler]
	public override function allTestMessages (message:TestMessage) : void {
		super.allTestMessages(message);
	}

	[MessageHandler(selector="test1")]
	public override function event1 (message:TestMessage) : void {
		super.event1(message);
	}
	
	[MessageHandler(selector="test2")]
	public override function event2 (message:TestMessage) : void {
		super.event2(message);
	}
	

}
}
