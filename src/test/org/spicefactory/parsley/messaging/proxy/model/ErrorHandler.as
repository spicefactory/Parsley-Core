package org.spicefactory.parsley.messaging.proxy.model {
import org.spicefactory.parsley.core.messaging.MessageProcessor;
import org.spicefactory.parsley.util.MessageCounter;

/**
 * @author Jens Halm
 */
public class ErrorHandler extends MessageCounter {
	
	
	[MessageError]
	public function handleMessage (processor:MessageProcessor, e:Error) : void {
		addMessage(processor.message);
	}
	
	
}
}
