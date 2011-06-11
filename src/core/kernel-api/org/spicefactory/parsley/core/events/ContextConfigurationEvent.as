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
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.context.Context;

import flash.events.Event;

/**
 * Event that fires when a new Context gets configured that is associated with a view root.
 * The event allows listeners in the view hierarchy above to transparently add configuration artifacts
 * before the Context gets built.
 * 
 * @author Jens Halm
 */
public class ContextConfigurationEvent extends Event {


	/**
	 * Constant for the type of bubbling event fired when a new Context gets configured that is 
	 * associated with a view root. The event allows listeners in the view hierarchy above to 
	 * transparently add configuration artifacts before the Context gets built.
	 * 
	 * @eventType configureContext
	 */
	public static const CONFIGURE_CONTEXT : String = "configureContext";
	

	private var _config:BootstrapConfig;
	private var _viewParent:Context;
	
	
	/**
	 * @private
	 */
	public function ContextConfigurationEvent (config:BootstrapConfig) {
		super(CONFIGURE_CONTEXT, true);
		_config = config;
	}
	
	/**
	 * The configuration to be used for the new Context.
	 */
	public function get config () : BootstrapConfig {
		return _config;
	}
	
	/**
	 * The parent Context found in the view hierarchy.
	 */
	public function get viewParent () : Context {
		return _viewParent;
	}
	
	public function set viewParent (value:Context) : void {
		_viewParent = value;
	}
	
	
	/**
	 * @private
	 */
	public override function clone () : Event {
		return new ContextConfigurationEvent(config);
	}		
	
	
}
}

