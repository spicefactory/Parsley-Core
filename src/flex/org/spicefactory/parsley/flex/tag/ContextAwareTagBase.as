/*
 * Copyright 2010 the original author or authors.
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

package org.spicefactory.parsley.flex.tag {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.events.ContextLookupEvent;

import flash.display.DisplayObject;

/**
 * Base class for MXML configuration tags that need to know the nearest Context in the view hierarchy above them.
 * Extends and thus supports all the features of <code>ConfigurationTagBase</code>.
 * Subclasses only have to overwrite the
 * template method <code>handleContext</code> for doing the actual work.
 * 
 * @author Jens Halm
 */
public class ContextAwareTagBase extends ConfigurationTagBase {
	
	
	private var requiredEvent:String;
	
	private var context:Context;
	
	private var view:DisplayObject;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param requiredEvent the event to wait for before invoking the handleContext method
	 * @param listenerPriority the priority to use when adding listeners to 
	 * the document object this tag is associated with
	 * @param stageBound true if the tag should wait until the associated 
	 * document object is added to the stage before performing its work
	 * @param supportsBindings true if this tag supports binding and thus
	 * has to wait until the associated document object is initialized before performing its work 
	 */
	function ContextAwareTagBase (requiredEvent:String = null, listenerPriority:int = 0, 
			stageBound:Boolean = true, supportsBindings:Boolean = true) {
		super(listenerPriority, stageBound, supportsBindings);
		this.requiredEvent = requiredEvent;
	}

	
	/**
	 * @private
	 */
	protected override function executeAction (view:DisplayObject) : void {
		this.view = view;
		var event:ContextLookupEvent = new ContextLookupEvent(contextFound);
		view.dispatchEvent(event);
		if (!event.processed) {
			handleContext(null, view);
		}
	}
	
	private function contextFound (context:Context) : void {
		this.context = context;
		if (!requiredEvent || !context) {
			handleContext(context, view);
			return;
		}
		else if (requiredEvent == ContextEvent.INITIALIZED) {
			if (context.initialized) {
				handleContext(context, view);
				return;
			}
		}
		else if (requiredEvent == ContextEvent.CONFIGURED) {
			if (context.configured) {
				handleContext(context, view);
				return;
			}
		}
		else {
			throw new IllegalStateError("Illegal type for required event: " + requiredEvent);
		}
		context.addEventListener(requiredEvent, handleContextEvent);	
	}
	
	/**
	 * Invoked when the specified context has been found in the view hierarchy and is in the required
	 * state. The required state depends on the <code>requiredEvent</code> parameter passed to the constructor
	 * (either <code>ContextEvent.INITIALIZED</code> or <code>ContextEvent.CONFIGURED</code> or <code>null</code>).
	 * If no Context was found the parameter will be null. It is up to the concrete tag implementation
	 * to decide whether this should be treated as an Error or not.
	 * 
	 * @param context the Context that was found in the view hierarchy above this tag or null if none was found
	 * @param view the fully initialized view this tag was placed upon
	 */
	protected function handleContext (context:Context, view:DisplayObject) : void {
		throw new AbstractMethodError();
	}
	
	private function handleContextEvent (event:ContextEvent) : void {
		context.removeEventListener(requiredEvent, handleContextEvent);
		handleContext(context, view);
	}
	
	
}
}
