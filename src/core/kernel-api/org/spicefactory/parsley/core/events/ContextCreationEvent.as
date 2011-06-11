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
 
package org.spicefactory.parsley.core.events {
import org.spicefactory.parsley.core.context.Context;

import flash.events.Event;

/**
 * Event that fires when a new Context was created that is associated with a view root.
 * The event allows listeners in the view hierarchy above to get hold of the new Context
 * without the need for the views that hold the Context to adhere to some sort of contract.
 * 
 * @author Jens Halm
 */
public class ContextCreationEvent extends Event {


	/**
	 * Constant for the type of bubbling event fired when a new Context was created that is associated with a view root.
 	 * The event allows listeners in the view hierarchy above to get hold of the new Context
 	 * without the need for the views that hold the Context to adhere to some sort of contract.
	 * 
	 * @eventType createContext
	 */
	public static const CREATE_CONTEXT : String = "createContext";
	

	private var _context:Context;
	
	
	/**
	 * @private
	 */
	public function ContextCreationEvent (context:Context) {
		super(CREATE_CONTEXT, true);
		_context = context;
	}
	
	/**
	 * The Context that was created.
	 */
	public function get context () : Context {
		return _context;
	}
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		return new ContextCreationEvent(context);
	}		
	
	
}
}

