package org.spicefactory.parsley.messaging.model {
import org.spicefactory.parsley.core.errors.ContextError;
import org.spicefactory.parsley.messaging.messages.TestEvent;

import flash.events.Event;

/**
 * @author Jens Halm
 */
public class FaultyMessageHandlers {

	
	public function allTestEvents (event:TestEvent) : void {
		throw new Error("Faulty handler");
	}
	
	public function allEvents (event:Event) : void {
		throw new Error("Faulty handler");
	}
	
	public function event1 (event:TestEvent) : void {
		throw new ContextError("Faulty handler");
	}
	
	public function event2 (event:TestEvent) : void {
		throw new ContextError("Faulty handler");
	}
	

}
}
