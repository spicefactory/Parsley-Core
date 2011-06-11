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
import org.spicefactory.parsley.core.context.Context;

import flash.events.Event;

/**
 * Event that fires when a new Context gets created that is associated with a view root.
 * 
 * @author Jens Halm
 */
public class FlexContextEvent extends Event {


	/**
	 * Constant for the type of event fired when a new Context has been fully initialized.
	 * 
	 * @eventType configureView
	 */
	public static const COMPLETE : String = "complete";
	
	
	private var _context:Context;
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param context the Context associated with this Event
	 */
	public function FlexContextEvent (context:Context) {
		super(COMPLETE);
		_context = context;
	}
	
	
	/**
	 * The Context that has been initialized.
	 */
	public function get context () : Context {
		return _context;
	}
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		return new FlexContextEvent(context);
	}	
	
	
}
}
