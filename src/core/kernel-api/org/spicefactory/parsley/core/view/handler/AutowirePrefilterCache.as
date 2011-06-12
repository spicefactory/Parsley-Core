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

package org.spicefactory.parsley.core.view.handler {

import flash.events.Event;
import flash.utils.Dictionary;

/**
 * Utility class that keeps track of all views that have already been prefiltered in a particular frame.
 * 
 * @author Jens Halm
 */
public class AutowirePrefilterCache {
	
	
	private static var cachedEvents:Dictionary = new Dictionary();
	private static var cachePurger:DelegateChain;
	
	
	/**
	 * Adds the specified Event to the cache.
	 * 
	 * @param event the event to add
	 * @return true if the event has been added to the cached, false if it has already been prefiltered
	 */
	public static function addEvent (event:Event) : Boolean {
		if (cachedEvents[event]) return false;
		cachedEvents[event] = true;
		if (cachePurger == null) {
			cachePurger = new DelayedDelegateChain(1);
			cachePurger.addDelegate(new Delegate(purgePrefilterCache));
		}
		return true;
	}
	
	private static function purgePrefilterCache () : void {
		cachePurger = null;
		cachedEvents = new Dictionary();
	}
	
	
}
}
