/*
 * Copyright 2011 the original author or authors.
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
import org.spicefactory.parsley.core.view.ViewConfiguration;

import flash.events.Event;

/**
 * Event that fires to demarcate the lifecycle of a managed view.
 * 
 * @author Jens Halm
 */
public class ViewLifecycleEvent extends Event {


	/**
	 * Constant for the type event fired when the managed view should get initialized.
	 * 
	 * @eventType initView
	 */
	public static const INIT_VIEW : String = "initView";
	
	/**
	 * Constant for the type event fired when the managed view should get destroyed.
	 * 
	 * @eventType destroyView
	 */
	public static const DESTROY_VIEW : String = "destroyView";
	
	private var _configuration:ViewConfiguration;
	
	
	/**
	 * Creates a new event instance.
	 * 
	 * @param type the type of the event
	 * @param configurations one or more ViewConfigurations that should get processed
	 */
	public function ViewLifecycleEvent (type:String, configuration:ViewConfiguration) {
		super(type);
		_configuration = configuration;
	}		
	
	/**
	 * The configuration of the managed view.
	 */
	public function get configuration () : ViewConfiguration {
		return _configuration;
	}

	
	/**
	 * @private
	 */
	public override function clone () : Event {
		return new ViewLifecycleEvent(type, configuration);
	}	
		
		
}
	
}