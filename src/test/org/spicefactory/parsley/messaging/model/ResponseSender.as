package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.messaging.MessageProcessor;

/**
 * @author Jens Halm
 */
public class ResponseSender {
	
	[MessageHandler(order="10")]
	public function message (msg:Object, processor:MessageProcessor) : void {
		if (msg != "response") processor.sendResponse("response");
	}
	
}
}
