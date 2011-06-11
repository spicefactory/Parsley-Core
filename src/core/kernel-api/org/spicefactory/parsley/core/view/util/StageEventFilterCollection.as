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

package org.spicefactory.parsley.core.view.util {
import flash.display.DisplayObject;
import flash.utils.Dictionary;

/**
 * Manages a group of StageEventFilters.
 * 
 * @author Jens Halm
 */
public class StageEventFilterCollection {
	
	
	private var handlers:Dictionary = new Dictionary();
	
	
	/**
	 * Adds a target to filter the stage events for. The specified handlers will only be invoked
	 * when an addedToStage or removedFromStage event occurs that is not just temporarily as those
	 * that fire when a DisplayObject gets reparented as the result of some LayoutManager operation (e.g.
	 * adding scrollbars).
	 * 
	 * <p>The parameter passed to the handlers is the DisplayObject, not the event.</p>
	 * 
	 * @param view the view to filter all stage events for
	 * @param removedHandler the handler to invoke for all real removedFromStage events
	 * @param addedHandler the handler to invoke for all real addedToStage events
	 */
	public function addTarget (view:DisplayObject, removedHandler:Function, addedHandler:Function = null) : void {
		handlers[view] = new StageEventFilter(view, removedHandler, addedHandler);
	}
	
	/**
	 * Removes a target so that stage event handlers are no longer invoked.
	 * 
	 * @param view the view to stop filtering stage events for
	 */
	public function removeTarget (view:DisplayObject) : void {
		var handler:StageEventFilter = handlers[view];
		if (handler) {
			handler.dispose();
			delete handlers[view];
		}
	}
	
	
}
}
