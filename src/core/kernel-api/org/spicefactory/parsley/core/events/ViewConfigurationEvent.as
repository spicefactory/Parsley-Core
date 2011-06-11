/*
 * Copyright 2009-2011 the original author or authors.
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
import org.spicefactory.parsley.core.view.impl.DefaultViewConfiguration;

import flash.display.DisplayObject;
import flash.events.Event;

/**
 * Event that fires when one or more view components wish to get processed by the nearest Context.
 * The Event allows to specify a custom <code>ViewProcessor</code> or <code>ViewLifecycle</code>
 * for each object getting processed. If not specified the default set by the Context will be used.
 * Processing a view can mean adding it to the Context or just injecting something into it without
 * making the view itself a managed component. It is a very generic event that just allows to pass
 * objects from the view to the nearest Context for any kind of processing.
 * 
 * @author Jens Halm
 */
public class ViewConfigurationEvent extends Event {


	/**
	 * Constant for the type of bubbling event explicitly fired by a view component that wishes to get 
	 * processed by the nearest Context in the view hierarchy.
	 * 
	 * @eventType configureView
	 */
	public static const CONFIGURE_VIEW : String = "configureView";
	
	/**
	 * Constant for the type of bubbling event automatically fired when a view component is a canididate
	 * for getting processed by the nearest Context in the view hierarchy.
	 * A candidate is a view component that passed the <code>prefilter</code> method of the active
	 * <code>ViewAutowireFilter</code> when autowiring is enabled.
	 * 
	 * @eventType autowireView
	 */
	public static const AUTOWIRE_VIEW : String = "autowireView";
	
	private var _received:Boolean;
	
	private var _configurations:Array;
	private var callback:Function;
	
	/**
	 * Creates a new event instance to be used to trigger the autowiring process.
	 * Should normally not be used in application code. The specified view must
	 * still pass the installed <code>ViewAutowireFilter</code>.
	 * 
	 * @param the view that is an autowiring candidate
	 * @return a new event instance
	 */
	public static function forAutowiring (view:DisplayObject) : ViewConfigurationEvent {
		return new ViewConfigurationEvent(AUTOWIRE_VIEW, [new DefaultViewConfiguration(view)]);
	}
	
	/**
	 * Creates a new event instance to be used for explicitly passing the specified target instance
	 * to the nearest Context in the view hierarchy for processing. If no target is specified the view itself
	 * will get passed. Otherwise the view merely acts as helper to demarcate
	 * the lifecycle of the actual target.
	 * 
	 * @param view the view that controls the lifecycle of the target
	 * @param target the target to get processed by the Context
	 * @param configId the configuration id to use to fetch matching definitions from the Context
	 * @return a new event instance
	 */
	public static function forExplicitTarget (view:DisplayObject, target:Object = null, configId:String = null) 
			: ViewConfigurationEvent {
		return new ViewConfigurationEvent(CONFIGURE_VIEW, [new DefaultViewConfiguration(view, target, configId)]);
	}
	
	/**
	 * Creates a new event instance to be used for explicitly passing the targets contained
	 * in the specified configuration instances to the nearest Context in the view hierarchy for processing.
	 * 
	 * @param configurations one or more ViewConfigurations that should get processed
	 * @param callback the no-arg callback to invoke after processing of this event has completed
	 * @return a new event instance
	 */
	public static function forConfigurations (configurations:Array, callback:Function = null) : ViewConfigurationEvent {
		return new ViewConfigurationEvent(CONFIGURE_VIEW, configurations, callback);
	}
	
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param type the type of the event
	 * @param configurations one or more ViewConfigurations that should get processed
	 */
	public function ViewConfigurationEvent (type:String, configurations:Array, callback:Function = null) {
		super(type, true);
		_configurations = configurations;
		this.callback = callback;
	}		
	
	/**
	 * The view configurations to get processed.
	 */
	public function get configurations () : Array {
		return _configurations;
	}
	
	/**
	 * Indicates whether this event instance has already been processed by a Context.
	 */
	public function get received () : Boolean {
		return _received;
	}
	
	/**
	 * Marks this event instance as received by a corresponding Context.
	 */
	public function markAsReceived () : void {
		_received = true;
	}
	
	/**
	 * Marks this event instance as processed by a corresponding Context.
	 */
	public function markAsCompleted () : void {
		if (callback) callback();
	}
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		return new ViewConfigurationEvent(type, configurations, callback);
	}	
		
		
}
	
}