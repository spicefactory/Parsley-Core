package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.messaging.messages.TestMessage;

/**
 * @author Jens Halm
 */
public class ErrorPolicyHandlers {
	
	
	public var messageCount:int = 0;
	
	
	[MessageHandler(order="1")]
	public function handleFirst (msg:TestMessage) : void {
		messageCount++;
	}
	
	[MessageHandler(order="2")]
	public function somethingFaulty (msg:TestMessage) : void {
		throw new Error("This is an expected error.");
	}
	
	[MessageHandler(order="3")]
	public function handleSecond (msg:TestMessage) : void {
		messageCount++;
	}
	
	
}
}
