package org.spicefactory.parsley.context.scope.model {
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * @author Jens Halm
 */
[Event(name="test")]
[ManagedEvents("test")]
public class GlobalSender extends EventDispatcher {
	
	
	[Init]
	public function init () : void {
		dispatchEvent(new Event("test"));
	}
	
	
}
}
