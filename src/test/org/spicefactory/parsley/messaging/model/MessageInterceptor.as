package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.messaging.messages.TestEvent;

/**
 * @author Jens Halm
 */
public class MessageInterceptor {
	
	
	public var test1Count:int = 0;
	
	[MessageHandler(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test1")]
	public function test1 (processor:MessageProcessor) : void {
		test1Count++;
	}
	

	public var stringProp:String = "";
	public var intProp:int;
	public var test2Count:int = 0;

	[MessageHandler(type="org.spicefactory.parsley.messaging.messages.TestEvent", selector="test2", messageProperties="stringProp,intProp")]
	public function test2 (stringProp:String, intProp:int, processor:MessageProcessor) : void {
		test2Count++;
		this.stringProp += stringProp;
		this.intProp = intProp;
	}
	
	[MessageHandler(order="1")]
	public function allTestEvents (message:TestEvent) : void {
		this.stringProp += "handler";
	}
	
	
}
}
