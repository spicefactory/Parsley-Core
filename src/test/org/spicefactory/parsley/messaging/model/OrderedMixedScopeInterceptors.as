package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.util.MessageCounter;

/**
 * @author Jens Halm
 */
public class OrderedMixedScopeInterceptors extends MessageCounter {
	
	public var order:String = "";
	public var processor:MessageProcessor;
	
	[MessageHandler(scope="local", order="1")]
	public function handleLocalMessage1 (message:String) : void {
		order += "B";
	}
	
	[MessageHandler(order="2")]
	public function handleGlobalMessage1 (message:Object) : void {
		order += "C";
	}
	
	[MessageHandler(scope="local", order="4")]
	public function handleLocalMessage2 (message:Object) : void {
		order += "E";
	}
	
	[MessageHandler]
	public function handleGlobalMessage2 (message:String) : void {
		order += "F";
	}
	
	[MessageHandler]
	public function globalInterceptor (message:String, processor:MessageProcessor) : void {
		this.processor = processor;
		order += "A";
		processor.suspend();
	}
	
	[MessageHandler(scope="local", order="3")]
	public function localInterceptor (message:String, processor:MessageProcessor) : void {
		this.processor = processor;
		order += "D";
		processor.suspend();
	}
	
}
}
