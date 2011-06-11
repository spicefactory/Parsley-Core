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
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.events.ViewConfigurationEvent;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.ViewLifecycle;
import org.spicefactory.parsley.core.view.impl.DefaultViewConfiguration;
import org.spicefactory.parsley.core.view.processor.FastInjectProcessor;

import flash.display.DisplayObject;
import flash.events.Event;

/**
 * Provides a fluent API for injecting a managed object from the nearest Context in the 
 * view hierarchy into a view without reflecting on the view.
 * This API can be used in ActionScript components (Flex or Flash) as an alternative
 * to the <code>&lt;FastInject&gt;</code> MXML tag for MXML components.
 * 
 * @author Jens Halm
 */
public class FastInject {
	
	
	private static const log:Logger = LogContext.getLogger(FastInject);
	
	
	private var _view:DisplayObject;
	private var _target:Object;
	
	private var _reuse:Boolean;
	private var _autoremove:Flag;
	private var _lifecycle:ViewLifecycle;
	private var _property:String;
	private var _type:Class;
	private var _objectId:String;
	
	private var _completeHandler:Function;
	
	
	/**
	 * The view that demarcates the lifecycle of the target instance to inject into.
	 * The view may be the same instance as the target itself or a different one
	 * that just controls the lifecycle. A typical example for the two properties 
	 * pointing to different instances would be the target being a presentation model
	 * that should get added to the Context for the time the view it belongs to is on
	 * the stage.
	 * 
	 * @param view the view that demarcates the lifecycle of the target instance
	 * @return a new Configure instance for further setup options
	 */
	public static function view (view:DisplayObject) : FastInject {
		return new FastInject(view);
	}
	
	
	/**
	 * @private
	 */
	function FastInject (view:DisplayObject) {
		_view = view;
	}
	
	
	/**
	 * The target to inject into.
	 * 
	 * @param target the target to get processed by the nearest Context in the view hierarchy
	 * @return this FastInject instance for method chaining
	 */
	public function target (target:Object) : FastInject {
		_target = target;
		return this;
	}
	
	/**
	 * Indicates whether the target instance will be reused in subsequent
	 * lifecycles of the view. When set to false the injection will
	 * only be processed once. This value should be true if the application
	 * keeps instances of the view in memory and adds them back to the stage
	 * later. It should be false if the view will get garbage collected once
	 * it has been removed from the stage.
	 * 
	 * @param reuse indicates whether the target instance will be reused in subsequent
	 * lifecycles of the view
	 * @return this FastInject instance for method chaining
	 */
	public function reuse (reuse:Boolean) : FastInject {
		_reuse = reuse;
		return this;
	}
	
	/**
	 * Indicates whether the injected object should be removed from the Context
	 * when the view is removed from the stage and the injected object is a DynamicObject. 
	 * Only has an effect when no custom <code>ViewLifecycle</code>
	 * has been set.
	 * 
	 * @param autoremove Indicates whether the injected object should be removed from the Context
	 * when the view is removed from the stage and the injected object is a DynamicObject
	 * @return this FastInject instance for method chaining
	 */
	public function autoremove (autoremove:Boolean) : FastInject {
		_autoremove = new Flag(autoremove);
		return this;
	}
	
	/**
	 * The instance that controls the lifecycle of the view.
	 * This property may be null, in this case the default lifecycle installed in the 
	 * Context for the type of view of this configuration will be used.
	 * 
	 * @param lifecycle the instance that controls the lifecycle of the view
	 * @return this FastInject instance for method chaining
	 */
	public function lifecycle (lifecycle:ViewLifecycle) : FastInject {
		_lifecycle = lifecycle;
		return this;
	}
	
	/**
	 * The name of the property of the target to inject into.
	 * 
	 * @param definition name of the property of the target to inject into
	 * @return this FastInject instance for method chaining
	 */
	public function property (property:String) : FastInject {
		_property = property;
		return this;
	}
	
	/**
	 * The id the object to inject is configured with in the Parsley Context.
	 * FastInject can do either injection by type or by id. Thus either this
	 * method or <code>type</code> must be called.
	 * 
	 * @param objectId the id the object to inject is configured with in the Parsley Context 
	 * @return this FastInject instance for method chaining
	 */
	public function objectId (objectId:String) : FastInject {
		_objectId = objectId;
		return this;
	}
	
	/**
	 * The type of the object to inject from the nearest Parsley Context.
	 * FastInject can do either injection by type or by id. Thus either this
	 * method or <code>objectId</code> must be called.
	 * 
	 * @param type the type of the object to inject from the nearest Parsley Context 
	 * @return this FastInject instance for method chaining
	 */
	public function type (type:Class) : FastInject {
		_type = type;
		return this;
	}
	
	/**
	 * A callback to invoke when the injection has been completed.
	 * 
	 * @param callback a callback to invoke when the injection has been completed
	 * @return this FastInject instance for method chaining
	 */
	public function complete (callback:Function) : FastInject {
		_completeHandler = callback;
		return this;
	}
	
	
	/**
	 * Triggers the (potentially asynchronous) injection.
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
		var config:ViewConfiguration = new DefaultViewConfiguration(_view, _target);
		if (!_type && !_objectId) {
			throw new IllegalStateError("Either type or objectId must be specified for FastInject into " + config.target);
		}
		config.reuse = _reuse;
		config.autoremove = _autoremove;
		config.processor = new FastInjectProcessor(_property, _type, _objectId);
		config.lifecycle = _lifecycle;
		var event:ViewConfigurationEvent = ViewConfigurationEvent.forConfigurations([config], _completeHandler);
		_view.dispatchEvent(event);
		if (!event.received) {
			log.warn("Fast injection could not be performed for target " + config.target
					+ ": no Context found in view hierarchy");
		}
	}
	
	
}
}
