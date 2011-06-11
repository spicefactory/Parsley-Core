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
import flash.events.Event;

/**
 * Utility class for filtering stage events that were only caused by reparenting a DisplayObject.
 * 
 * @author Jens Halm
 */
public class StageEventFilter {
	
	
	private var view:DisplayObject;
	private var removedHandler:Function;
	private var addedHandler:Function;
	
	private var removedInCurrentFrame:Boolean;
	
	
	/**
	 * Creates a new instance that filters events for the specified view.
	 * 
	 * @param view the view for which to filter stage events
	 * @param removedHandler the handler to invoke for filtered removedFromStage events
	 * @param removedHandler the handler to invoke for filtered addedToStage events
	 */
	function StageEventFilter (view:DisplayObject, removedHandler:Function, addedHandler:Function = null) {
		this.view = view;
		this.removedHandler = removedHandler;
		this.addedHandler = addedHandler;
		view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}
	
	
	/**
	 * Instructs this filter to stop listening to stage events.
	 */
	public function dispose () : void {
		view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		view.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		view.removeEventListener(Event.ENTER_FRAME, enterFrame);
	}
	
	private function addedToStage (event:Event) : void {
		if (removedInCurrentFrame) {
			resetFrame();
		}
		else if (addedHandler != null) {
			addedHandler(view);
		}
	}
	
	private function removedFromStage (event:Event) : void {
		removedInCurrentFrame = true;
		view.addEventListener(Event.ENTER_FRAME, enterFrame);
	}
	
	private function enterFrame (event:Event) : void {
		resetFrame();
		removedHandler(view);
	}
	
	private function resetFrame () : void {
		removedInCurrentFrame = false;
		view.removeEventListener(Event.ENTER_FRAME, enterFrame);
	}
	
	
}
}

