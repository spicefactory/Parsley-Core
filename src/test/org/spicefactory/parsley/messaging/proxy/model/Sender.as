package org.spicefactory.parsley.messaging.proxy.model {
	
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * @author Jens Halm
 */
[Event(name="test")]
[ManagedEvents("test")]
public class Sender extends EventDispatcher {
	
	
	[Init]
	public function init () : void {
		if (MessageHandlerReceiver.instanceCount > 0) {
			throw new Error("No Receiver should have been created at this point");
		}
		dispatchEvent(new Event("test"));
	}
	
	
}
}
