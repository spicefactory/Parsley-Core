package org.spicefactory.parsley.core.events {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.core.context.Context;

import flash.events.Event;

/**
 * Bubbling Event that may be fired by components that want to find out the nearest Context in the view hierarchy above them.
 * 
 * @author Jens Halm
 */
public class ContextLookupEvent extends Event {
	
	
	/**
	 * Constant for the type of bubbling event fired when components want to find out the nearest
	 * Context in the view hierarchy above them.
	 * 
	 * @eventType configureView
	 */
	public static const LOOKUP : String = "lookup";
	
	
	private var _processed:Boolean;
	private var _context:Context;
	private var callback:Function;
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param callback the function to invoke as soon as the Context has been determined
	 */
	public function ContextLookupEvent (callback:Function) {
		super(LOOKUP, true);
		this.callback = callback;
	}

	
	/**
	 * The nearest Context in the view hieararchy above the component that fired the Event 
	 * (or null if there is no such Context).
	 */
	public function get context () : Context {
		return _context;
	}
	
	public function set context (value:Context) : void {
		if (_context != null) {
			throw new IllegalStateError("Context has already been set for this event");
		}
		_context = value;
		callback(_context);
	}	
	
	/**
	 * Indicates whether this event instance has already been processed by a Context.
	 */
	public function get processed () : Boolean {
		return _processed;
	}
	
	/**
	 * Marks this event instance as processed by a corresponding Context.
	 */
	public function markAsProcessed () : void {
		_processed = true;
	}
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		var cbe:ContextLookupEvent = new ContextLookupEvent(callback);
		cbe.context = context;
		return cbe;
	}		
	
	
}
}
