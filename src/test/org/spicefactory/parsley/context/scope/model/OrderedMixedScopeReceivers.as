package org.spicefactory.parsley.context.scope.model {
import org.spicefactory.parsley.util.MessageCounter;

/**
 * @author Jens Halm
 */
public class OrderedMixedScopeReceivers extends MessageCounter {
	
	public var order:String = "";
	
	[MessageHandler(scope="local", order="1")]
	public function handleLocalMessage2 (message:String) : void {
		order += (message == "response") ? "1" : "A";
	}
	
	[MessageHandler(order="2")]
	public function handleGlobalMessage2 (message:Object) : void {
		order += (message == "response") ? "2" : "B";
	}
	
	[MessageHandler(scope="local", order="3")]
	public function handleLocalMessage (message:Object) : void {
		order += (message == "response") ? "3" : "C";
	}
	
	[MessageHandler]
	public function handleGlobalMessage (message:String) : void {
		order += (message == "response") ? "4" : "D";
	}
	
}
}
