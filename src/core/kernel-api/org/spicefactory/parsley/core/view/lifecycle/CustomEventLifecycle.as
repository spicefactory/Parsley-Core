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

package org.spicefactory.parsley.core.view.lifecycle {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ViewLifecycleEvent;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.ViewLifecycle;

import flash.events.Event;
import flash.events.EventDispatcher;

/**
 * Implementation of the ViewLifecycle interface that listens to custom events dispatched by the target 
 * ("configureView" and "removeView") to demarcate the lifecycle of the target.
 * 
 * <p>This lifecycle implementation gets used per default when no custom lifecycle has been installed
 * for the type of the target and the <code>autoremoveViewRoots</code> or <code>autoremoveComponents</code>
 * is set to false. The former setting is only considered for the actual view roots of a Context,
 * the latter for all other regular components.</p>
 * 
 * @author Jens Halm
 */
public class CustomEventLifecycle extends EventDispatcher implements ViewLifecycle {
	
	
	private static const log:Logger = LogContext.getLogger(CustomEventLifecycle);
	
	private static const REMOVE_VIEW:String = "removeView";
	private static const CONFIGURE_VIEW:String = "configureView";

	
	private var config:ViewConfiguration;
	
	
	/**
	 * @inheritDoc
	 */
	public function start (config:ViewConfiguration, context:Context) : void {
		this.config = config;
		config.view.addEventListener(REMOVE_VIEW, removeView);
		if (config.reuse && config.reuse.value) {
			config.view.addEventListener(CONFIGURE_VIEW, configureView);
		}
	}
	
	/**
	 * @inheritDoc
	 */
	public function stop () : void {
		config.view.removeEventListener(REMOVE_VIEW, removeView);
		if (config.reuse && config.reuse.value) {
			config.view.removeEventListener(CONFIGURE_VIEW, configureView);
		}
		config = null;
	}
	
	private function removeView (event:Event) : void {
		if (!config) return;
		log.debug("View '{0}' dispatched custom remove event", event.target);
		dispatchEvent(new ViewLifecycleEvent(ViewLifecycleEvent.DESTROY_VIEW, config));
	}
	
	private function configureView (event:Event) : void {
		if (!config) return;
		log.debug("Reusable view '{0}' processed again", event.target);
		dispatchEvent(new ViewLifecycleEvent(ViewLifecycleEvent.INIT_VIEW, config));
	}
	
	
}
}
