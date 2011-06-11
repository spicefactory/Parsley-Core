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

package org.spicefactory.parsley.dsl.context {
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.view.ViewAutowireFilter;

/**
 * Builder for settings related to view wiring.
 * 
 * @author Jens Halm
 */
public class ViewSettingsBuilder implements SetupPart {
	
	
	private var setup:ContextBuilderSetup;
	
	private var _autowireFilter:ViewAutowireFilter;
	private var _autowireComponents:Flag;
	private var _autoremoveComponents:Flag;
	private var _autoremoveViewRoots:Flag;
	
	private var viewProcessorBuilder:ServiceBuilder;
	private var viewLifecycles:Array = new Array();
	
	
	/**
	 * @private
	 */
	function ViewSettingsBuilder (setup:ContextBuilderSetup) {
		this.setup = setup;
	}

	
	/**
	 * Sets the filter responsible for selecting views that should be autowired to the Context.
	 * 
	 * <p>The framework has a builtin autowire filter that automatically picks those components
	 * that have a matching %lt;View&gt; tag in the MXML or XML configuration. If you want to
	 * rely on this behaviour you just have to call <code>autowireComponents(true)</code> on this
	 * builder. A custom filter can be used to apply a different behaviour, like picking components
	 * simply based on class or package names.</p>
	 * 
	 * @param filter the filter responsible for selecting views that should be autowired to the Context
	 * @return the original setup instance for method chaining
	 */	
	public function autowireFilter (filter:ViewAutowireFilter) : ContextBuilderSetup {
		_autowireFilter = filter;	
		return setup;
	}
	
	/**
	 * Indicates whether view components will be automatically wired to the
	 * Context. The default value is false. If set to true the only requirement
	 * for a view to get wired is that a corresponding %lt;View&gt; tag is added
	 * to the MXML or XML configuration. When set to false the component must explicitly
	 * signal that it wishes to get wired to the Context through dispatching a "configureView"
	 * event of adding a &lt;parsley:Configure/&gt; tag.
	 * 
	 * @param value whether view components will be automatically wired to the Context
	 * @return the original setup instance for method chaining
	 */	
	public function autowireComponents (value:Boolean) : ContextBuilderSetup {
		_autowireComponents = new Flag(value);		
		return setup;
	}
	
	/**
	 * Indicates whether components should automatically be removed from the Context
	 * when they are removed from the stage. The default value is true.
	 * When set to false the component must dispatch a custom "removeView" 
	 * event type to signal that it wishes to be removed from the Context.
	 * When set to true the removedFromStage event will be used instead.
	 * The framework will ignore intermediate stage events caused
	 * by LayoutManagers performing some kind of reparenting to make it 
	 * more robust. 
	 * 
	 * @param value whether components should automatically be removed from the Context
	 * when they are removed from the stage
	 * @return the original setup instance for method chaining
	 */	
	public function autoremoveComponents (value:Boolean) : ContextBuilderSetup {
		_autoremoveComponents = new Flag(value);	
		return setup;
	}
	
	/**
	 * Indicates whether view root should automatically be removed from the Context
	 * when they are removed from the stage. The default value is true.
	 * When set to false the view root must dispatch a custom "removeView" 
	 * event type to signal that it wishes to be removed from the Context.
	 * When set to true the removedFromStage event will be used instead.
	 * The framework will ignore intermediate stage events caused
	 * by LayoutManagers performing some kind of reparenting to make it 
	 * more robust. 
	 * 
	 * <p>The difference to the setting for component removal is that
	 * a view root is the actual display object that listens to bubbling
	 * events from the components below. If you are using the <code>&lt;ContextBuilder&gt;</code>
	 * MXML tag then the component it is placed upon automatically becomes a view root 
	 * for the Context created by that builder. Further view roots for popups or windows
	 * may be added explicitly through <code>ViewManager.addViewRoot()</code>.</p>
	 * 
	 * @param value whether view roots should automatically be removed from the Context
	 * when they are removed from the stage
	 * @return the original setup instance for method chaining
	 */	
	public function autoremoveViewRoots (value:Boolean) : ContextBuilderSetup {
		_autoremoveViewRoots = new Flag(value);
		return setup;
	}
	
	/**
	 * The view processor service registration for these settings.
	 * This hook allows to install alternative implementations to be used for processing all
	 * views in the associated Context and its children unless overwritten in a child.
	 * 
	 * <p>When specifying an implementation or decorator for this service, it must implement the
	 * <code>ViewProcessor</code> interface.</p>
	 * 
	 * @return the builder for specifying the implementation or decorators for the ViewProcessor
	 */
	public function viewProcessor () : ServiceBuilder {
		viewProcessorBuilder = new ServiceBuilder(setup);
		return viewProcessorBuilder;
	}
	
	/**
	 * Adds a lifecycle handler class for a particular type of view component.
	 * This hook allows to control the lifecycle differently than with the default
	 * handler.
	 * An example use case is an AIR window which has unreliable stage events, 
	 * so that it is safer to listen to its <code>CLOSE</code> event instead.
	 * 
	 * <p>The specified lifecylce class must implement the <code>ViewLifecycle</code> interface.</p>
	 * 
	 * @param viewType the class for which to use the specified lifecycle class (this includes subclasses)
	 * @param lifecycle the lifecycle class to instantiate for each view instance
	 * @param params parameters to get passed to the constructor of the lifecylce class 
	 * @return the original setup instance for method chaining
	 */
	public function addViewLifecycle (viewType:Class, lifecycle:Class, ...params) : ContextBuilderSetup {
		viewLifecycles.push(new LifecycleSetup(viewType, lifecycle, params));
		return setup;
	}
	
	/**
	 * @private
	 */
	public function apply (config:BootstrapConfig) : void {
		if (_autowireFilter != null) {
			config.viewSettings.autowireFilter = _autowireFilter;
		}
		if (_autowireComponents != null) {
			config.viewSettings.autowireComponents = _autowireComponents.value;
		}
		if (_autoremoveComponents != null) {
			config.viewSettings.autoremoveComponents = _autoremoveComponents.value;
		}
		if (_autoremoveViewRoots != null) {
			config.viewSettings.autoremoveViewRoots = _autoremoveViewRoots.value;
		}
		if (viewProcessorBuilder != null) {
			viewProcessorBuilder.configureService(config.viewSettings.viewProcessor);
		}
		for each (var lifecycle:LifecycleSetup in viewLifecycles) {
			lifecycle.apply(config.viewSettings.addViewLifecycle);
		}
	}
	
	
}
}

class LifecycleSetup {
	private var params:Array;
	function LifecycleSetup (viewType:Class, lifecycle:Class, params:Array) {
		this.params = [viewType, lifecycle].concat(params);
	}
	public function apply (f:Function) : void {
		f.apply(null, params);
	}
}


