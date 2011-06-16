package org.spicefactory.parsley.messaging.proxy.model {
import org.spicefactory.parsley.util.MessageCounter;

/**
 * @author Jens Halm
 */
public class MessageHandlerReceiver extends MessageCounter {
	
	
	public static var instanceCount:int = 0;
	
	function MessageHandlerReceiver () {
		instanceCount++;
	}
	
	[MessageHandler]
	public function handleMessage (message:Object) : void {
		addMessage(message);
	}
	
	
}
}
