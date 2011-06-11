/*
 * Copyright 2009 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
package org.spicefactory.parsley.flex.tag.builder {
import flash.events.Event;

/**
 * Event that fires when an MXML ContextBuilder tag wants to synchronize with its potential parent.
 * This Event deals with low level framework internals and should not be used by application code.
 * 
 * @author Jens Halm
 */
public class ContextBuilderSyncEvent extends Event {


	/**
	 * Constant for the type of bubbling event fired when an MXML ContextBuilder tag
	 * wants to synchronize with its potential parent.
	 * 
	 * @eventType syncBuilder
	 */
	public static const SYNC_BUILDER : String = "syncBuilder";
	
	
	private var _deferred:Boolean;
	private var _callback:Function;
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param callback a function a parent ContextBuilder invokes in case child creation must be deferred
	 */
	public function ContextBuilderSyncEvent (callback:Function) {
		super(SYNC_BUILDER, true);
		_callback = callback;
	}

	/**
	 * Indicates whether child Context creation must be deferred until the parent ContextBuilder
	 * invokes the specified callback.
	 */
	public function get deferred () : Boolean {
		return _deferred;
	}
	
	public function set deferred (value:Boolean) : void {
		_deferred = value;
	}
	
	/**
	 * The callback to be invoked by parent ContextBuilders in case child Context creation must be deferred.
	 */
	public function get callback () : Function {
		return _callback;
	}
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		var event:ContextBuilderSyncEvent = new ContextBuilderSyncEvent(callback);
		event.deferred = deferred;
		return event;
	}		
	
	
}
}
