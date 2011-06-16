package org.spicefactory.parsley.util {

/**
 * @author Jens Halm
 */
public class MessageReceiverBase {
	
	
	private var messageCounter:MessageCounter = new MessageCounter();
	
	
	protected function addMessage (message:Object, selector:* = undefined) : void {
		messageCounter.addMessage(message, selector);
	}
	
	public function getMessageCount (type:Class = null, selector:* = undefined) : int {
		return messageCounter.getCount(type, selector);
	}
	
	
}
}
