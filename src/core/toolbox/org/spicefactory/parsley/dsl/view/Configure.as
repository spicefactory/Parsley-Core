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

package org.spicefactory.parsley.dsl.view {
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.events.ViewConfigurationEvent;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.ViewLifecycle;
import org.spicefactory.parsley.core.view.ViewProcessor;
import org.spicefactory.parsley.core.view.impl.DefaultViewConfiguration;

import flash.display.DisplayObject;
import flash.events.Event;

/**
 * Provides a fluent API for configuring a target in a view.
 * This API can be used in ActionScript components (Flex or Flash) as an alternative
 * to the <code>&lt;Configure&gt;</code> MXML tag for MXML components.
 * 
 * @author Jens Halm
 */
public class Configure {
	
	
	private static const log:Logger = LogContext.getLogger(Configure);
	
	
	private var _view:DisplayObject;
	private var _target:Object;
	
	private var _reuse:Boolean;
	private var _autoremove:Flag;
	private var _processor:ViewProcessor;
	private var _lifecycle:ViewLifecycle;
	private var _definition:DynamicObjectDefinition;
	private var _configId:String;
	
	private var _completeHandler:Function;
	
	
	/**
	 * The view that demarcates the lifecycle of the target instance to be configured.
	 * The view may be the same instance as the target itself or a different one
	 * that just controls the lifecycle. A typical example for the two properties 
	 * pointing to different instances would be the target being a presentation model
	 * that should get added to the Context for the time the view it belongs to is on
	 * the stage.
	 * 
	 * @param view the view that demarcates the lifecycle of the target instance
	 * @return a new Configure instance for further setup options
	 */
	public static function view (view:DisplayObject) : Configure {
		return new Configure(view);
	}
	
	
	/**
	 * @private
	 */
	function Configure (view:DisplayObject) {
		_view = view;
	}
	
	
	/**
	 * The target to get processed by the nearest Context in the view hierarchy.
	 * 
	 * @param target the target to get processed by the nearest Context in the view hierarchy
	 * @return this Configure instance for method chaining
	 */
	public function target (target:Object) : Configure {
		_target = target;
		return this;
	}
	
	/**
	 * Indicates whether the target instance will be reused in subsequent
	 * lifecycles of the view. When set to false the configuration will
	 * only be processed once. This value should be true if the application
	 * keeps instances of the view in memory and adds them back to the stage
	 * later. It should be false if the view will get garbage collected once
	 * it has been removed from the stage.
	 * 
	 * @param reuse indicates whether the target instance will be reused in subsequent
	 * lifecycles of the view
	 * @return this Configure instance for method chaining
	 */
	public function reuse (reuse:Boolean) : Configure {
		_reuse = reuse;
		return this;
	}
	
	/**
	 * Indicates whether the target should be removed when the view is removed
	 * from the stage. Only has an effect when no custom <code>ViewLifecycle</code>
	 * has been set.
	 * 
	 * @param autoremove Indicates whether the target should be removed when the view is removed
	 * from the stage
	 * @return this Configure instance for method chaining
	 */
	public function autoremove (autoremove:Boolean) : Configure {
		_autoremove = new Flag(autoremove);
		return this;
	}

	/**
	 * The processor to use for the target instance.
	 * This property may be null, in this case the default processor installed in the 
	 * Context will be used.
	 * 
	 * @param processor the processor to use for the target instance
	 * @return this Configure instance for method chaining
	 */
	public function processor (processor:ViewProcessor) : Configure {
		_processor = processor;
		return this;
	}
	
	/**
	 * The instance that controls the lifecycle of the view.
	 * This property may be null, in this case the default lifecycle installed in the 
	 * Context for the type of view of this configuration will be used.
	 * 
	 * @param lifecycle the instance that controls the lifecycle of the view
	 * @return this Configure instance for method chaining
	 */
	public function lifecycle (lifecycle:ViewLifecycle) : Configure {
		_lifecycle = lifecycle;
		return this;
	}
	
	/**
	 * The object definition to use to configure the target.
	 * This property is optional. Some ViewProcessors may look for
	 * an object definition in the Context that matches the target
	 * instance getting processed when this value is null.
	 * 
	 * @param definition the object definition to use to configure the target
	 * @return this Configure instance for method chaining
	 */
	public function definition (definition:DynamicObjectDefinition) : Configure {
		_definition = definition;
		return this;
	}
	
	/**
	 * The configuration id to use to look up an object definition 
	 * matching this target instance. If a definition has already
	 * been set for this configuration instance, this value will
	 * be ignored.
	 * 
	 * @param configId the configuration id to use to look up an object definition 
	 * matching this target instance
	 * @return this Configure instance for method chaining
	 */
	public function configId (configId:String) : Configure {
		_configId = configId;
		return this;
	}
	
	/**
	 * A callback to invoke when the processing of the view configuration has been completed.
	 * 
	 * @param callback a callback to invoke when the processing of the view configuration has been completed
	 * @return this Configure instance for method chaining
	 */
	public function complete (callback:Function) : Configure {
		_completeHandler = callback;
		return this;
	}
	
	
	/**
	 * Executes this view configuration at the nearest Context in the view hierarchy.
	 */
	public function execute () : void {
		if (!_view.stage) {
			_view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		else {
			dispatchEvent();
		}
	}
	
	private function addedToStage (event:Event) : void {
		_view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		dispatchEvent();
	}
	
	private function dispatchEvent () : void {
		var config:ViewConfiguration = new DefaultViewConfiguration(_view, _target, _configId);
		config.reuse = _reuse;
		config.autoremove = _autoremove;
		config.processor = _processor;
		config.lifecycle = _lifecycle;
		config.definition = _definition;
		var event:ViewConfigurationEvent = ViewConfigurationEvent.forConfigurations([config], _completeHandler);
		_view.dispatchEvent(event);
		if (!event.received) {
			log.warn("View configuration could not be processed for target " + config.target
					+ ": no Context found in view hierarchy");
		}
	}
	
	
}
}
