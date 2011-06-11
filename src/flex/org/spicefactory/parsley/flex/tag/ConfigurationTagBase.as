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

package org.spicefactory.parsley.flex.tag {
import org.spicefactory.lib.errors.AbstractMethodError;
import org.spicefactory.lib.errors.IllegalArgumentError;

import mx.core.IMXMLObject;
import mx.core.UIComponent;
import mx.events.FlexEvent;

import flash.display.DisplayObject;
import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * Base class for MXML configuration tags that may require both, the associated document component being added to the stage
 * and the bindings for the tag being executed, before performing its work. Both requirements are configurable so that the class
 * can be used for tags that require only one of these conditions to be true. Subclasses only have to overwrite the
 * template method <code>executeAction</code> for doing the actual work.
 * 
 * @author Jens Halm
 */
public class ConfigurationTagBase extends EventDispatcher implements IMXMLObject {
	
	
	private var listenerPriority:int = 0;
	private var stageBound:Boolean;
	private var supportsBindings:Boolean;
	
	private var componentInitialized:Boolean = false;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param listenerPriority the priority to use when adding listeners to 
	 * the document object this tag is associated with
	 * @param stageBound true if the tag should wait until the associated 
	 * document object is added to the stage before performing its work
	 * @param supportsBindings true if this tag supports binding and thus
	 * has to wait until the associated document object is initialized before performing its work 
	 */
	function ConfigurationTagBase (listenerPriority:int = 0, 
			stageBound:Boolean = true, supportsBindings:Boolean = true) {
		this.listenerPriority = listenerPriority;
		this.stageBound = stageBound;
		this.supportsBindings = supportsBindings;
	}

	
	/**
	 * Invoked when the specified view has been added to the stage
	 * and is fully initialized (in case it is a Flex component).
	 * The default implementation throws an Error, subclasses are expected
	 * to override this method. The view is the document instance
	 * associated with this tag class.
	 * 
	 * @param view the fully initialized view
	 */
	protected function executeAction (view:DisplayObject) : void {
		throw new AbstractMethodError(); 
	}
	
	
	/**
	 * @private
	 */
	public function initialized (document:Object, id:String) : void {
		if (!(document is DisplayObject)) {
			throw new IllegalArgumentError("The tag is supposed to be used within MXML components that extend DisplayObject");
		}
		var view:DisplayObject = DisplayObject(document);
		
		if (!waitForStage(view) && !waitForBindings(view)) {
			executeAction(view);
			return;
		}
		if (waitForStage(view)) {
			view.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, listenerPriority);
		} 
		if (waitForBindings(view)) {
			view.addEventListener(FlexEvent.INITIALIZE, viewInitialized, false, listenerPriority);
		}
	}
	
	private function addedToStage (event:Event) : void  {
		var view:DisplayObject = DisplayObject(event.target);
		view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		if (!waitForBindings(view)) {
			executeAction(view);
		}
	}
	
	private function viewInitialized (event:Event) : void  {
		var view:DisplayObject = DisplayObject(event.target);
		view.removeEventListener(FlexEvent.INITIALIZE, viewInitialized);
		componentInitialized = true;
		if (!waitForStage(view)) {
			executeAction(view);
		}
	}
	
	private function waitForBindings (view:DisplayObject) : Boolean {
		return (supportsBindings && (view is UIComponent) && !componentInitialized && !UIComponent(view).initialized);
	}
	
	private function waitForStage (view:DisplayObject) : Boolean {
		return (stageBound && view.stage == null);
	}
	
	
}
}
