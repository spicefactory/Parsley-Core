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

package org.spicefactory.parsley.flex.tag.builder {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfigProcessor;

/**
 * MXML tag for declaring a custom view lifecycle to be used by the corresponding
 * Context for all matching view types. 
 * The tag can be used as a child tag of the ContextBuilder tag:
 * 
 * <pre><code>&lt;parsley:ContextBuilder&gt;
 *     &lt;parsley:ViewLifecycle viewType="{Window}" lifecycle="{AirWindowLifecycle}"/&gt;
 *     &lt;parsley:FlexConfig type="{BookStoreConfig}"/&gt;
 *     &lt;parsley:XmlConfig file="logging.xml"/&gt;
 * &lt;/parsley:ContextBuilder&gt;</code></pre> 
 * 
 * @author Jens Halm
 */
public class ViewLifecycleTag implements BootstrapConfigProcessor {
	
	/**
	 * The type for which this lifecycle should be applied.
	 * This will include all subtypes of the specified class.
	 */
	public var viewType:Class;
	
	/**
	 * The type of the lifecycle. 
	 * The specified class must implement the <code>ViewLifecycle</code> interface.
	 */
	public var lifecycle:Class;
	
	/**
	 * Optional parameters the parameters to pass to the constructor of the lifecycle instance.
	 */
	public var params:Array = new Array();
	
	/**
	 * @private
	 */
	public function processConfig (config:BootstrapConfig) : void {
		var params:Array = [viewType, lifecycle].concat(this.params);
		config.viewSettings.addViewLifecycle.apply(null, params);
	}
	
}
}
