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

package org.spicefactory.parsley.core.view {
import flash.display.DisplayObject;

/**
 * Filter that can be used to select views that should be wired to the Context.
 * Autowiring views based on a filter is an alternative mechanism to explicitly
 * specifying views to be wired with the <code>&lt;Configure&gt;</code> tag.
 * 
 * @author Jens Halm
 */
public interface ViewAutowireFilter {
	
	[Deprecated(replacement="ViewSettings.autowireComponents")]
	function get enabled () : Boolean;
	
	function set enabled (value:Boolean) : void;
	
	/**
	 * The event type to listen to in the view roots. The listener will be registered for 
	 * the capture phase and then pass all views to the prefilter method. The default is
	 * <code>Event.ADDED_TO_STAGE</code>.
	 */
	function get eventType () : String;
	
	function set eventType (value:String) : void;
	
	/**
	 * Prefilters the specified view object, deciding whether it should be further processed.
	 * This is primarily for performance optimizations as the final decision whether a view
	 * gets wired or not will be made by the filter method. Only objects for which this method
	 * returns true will then dispatch a bubbling autowire event. This is necessary as we have to
	 * listen in the capture phase first to get a hold on every view object, but must then
	 * reroute the event from bottom to top to allow the Context with the lowest position
	 * in the view hierarchy to make the final decision.
	 * 
	 * @param object the view object to be filtered
	 * @return true if the specified view object should be further processed.
	 */
	function prefilter (object:DisplayObject) : Boolean;
	
	/**
	 * Makes the final decision whether a view object should be wired to the Context.
	 * 
	 * <p>This method will only be invoked for objects which passed the prefilter method.
	 * In a multi-Context scenario in a modular application this method may be invoked
	 * in a different filter instance than the prefilter method. The latter will be invoked
	 * in the root Context in most cases, this method however will often be invoked in a child
	 * Context.</p>
	 * 
	 * <p>The enumeration value returned by this method indicates how the framework should
	 * deal with this view object. See the <code>ViewAutowireMode</code> class for details.</p>
	 * 
	 * @param object the view object to filter
	 * @return an enumeration value that indicates how the framework should
	 * deal with this view object
	 */
	function filter (object:DisplayObject) : ViewAutowireMode;
	
}
}
