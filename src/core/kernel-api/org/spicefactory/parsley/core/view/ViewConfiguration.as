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

package org.spicefactory.parsley.core.view {
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;

import flash.display.DisplayObject;

/**
 * Represents the configuration for a single target in a view to get processed by the
 * nearest Context in the view hierarchy above.
 * 
 * @author Jens Halm
 */
public interface ViewConfiguration {
	
	/**
	 * The target to get processed by the nearest Context in the view hierarchy.
	 */
	function get target () : Object;

	/**
	 * The view that demarcates the lifecycle of the target instance.
	 * The view may be the same instance as the target itself or a different one
	 * that just controls the lifecycle. A typical example for the two properties 
	 * pointing to different instances would be the target being a presentation model
	 * that should get added to the Context for the time the view it belongs to is on
	 * the stage.
	 */
	function get view () : DisplayObject;

	/**
	 * The processor to use for the target instance.
	 * This property may be null, in this case the default processor installed in the 
	 * Context will be used.
	 */
	function get processor () : ViewProcessor;
	
	function set processor (value : ViewProcessor) : void;

	/**
	 * The instance that controls the lifecycle of the view.
	 * This property may be null, in this case the default lifecycle installed in the 
	 * Context for the type of view of this configuration will be used.
	 */
	function get lifecycle () : ViewLifecycle;
	
	function set lifecycle (value : ViewLifecycle) : void;
	
	/**
	 * Indicates whether the target should be removed when the view is removed
	 * from the stage. Only has an effect when no custom <code>ViewLifecycle</code>
	 * has been set. The exact action to be performed when the view gets removed
	 * from the stage is determined by the <code>destroy</code> method of the
	 * <code>ViewProcessor</code>.
	 */
	function get autoremove () : Flag;
	
	function set autoremove (value:Flag) : void;

	/**
	 * The object definition to use to configure the target.
	 * This property is optional. Some ViewProcessors may look for
	 * an object definition in the Context that matches the target
	 * instance getting processed when this value is null.
	 */
	function get definition () : DynamicObjectDefinition;
	
	function set definition (value:DynamicObjectDefinition) : void;
	
	/**
	 * The configuration id to use to look up an object definition 
	 * matching this target instance. If a definition has already
	 * been set for this configuration instance, this value will
	 * be ignored.
	 */
	function get configId () : String;
	
	/**
	 * Indicates whether the target instance will be reused in subsequent
	 * lifecycles of the view. When set to false the configuration will
	 * only be processed once. This value should be true if the application
	 * keeps instances of the view in memory and adds them back to the stage
	 * later. It should be false if the view will get garbage collected once
	 * it has been removed from the stage.
	 */
	function get reuse () : Boolean;
	
	function set reuse (value:Boolean) : void;
	
	
}
}
