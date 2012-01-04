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

package org.spicefactory.parsley.core.view.impl {
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.bootstrap.impl.DefaultService;
import org.spicefactory.parsley.core.bootstrap.impl.ServiceFactory;
import org.spicefactory.parsley.core.context.LookupStatus;
import org.spicefactory.parsley.core.context.impl.DefaultLookupStatus;
import org.spicefactory.parsley.core.view.ViewAutowireFilter;
import org.spicefactory.parsley.core.view.ViewLifecycle;
import org.spicefactory.parsley.core.view.ViewProcessor;
import org.spicefactory.parsley.core.view.ViewRootHandler;
import org.spicefactory.parsley.core.view.ViewSettings;

/**
 * Default implementation of the ViewSettings interface.
 * 
 * @author Jens Halm
 */
public class DefaultViewSettings implements ViewSettings {


	private var _parents:Array = new Array();
	
	private var _autodestroyContext:Flag;
	private var _autoremoveViewRoots:Flag;
	private var _autoremoveComponents:Flag;
	private var _autowireComponents:Flag;
	private var _autowireFilter:ViewAutowireFilter;
	private var _viewRootHandlers:Array = new Array();

	
	/**
	 * Adds a parent for looking up values not set in this instance.
	 * 
	 * @param a parent settings instance
	 */
	public function addParent (parent:ViewSettings) : void {
		_parents.push(parent);
		_viewProcessor.addParent(parent.viewProcessor);
	}

	
	/**
	 * @inheritDoc
	 */
	public function get autodestroyContext () : Boolean {
		return (_autodestroyContext) 
				? _autodestroyContext.value 
				: ((_parents.length) ? _parents[0].autodestroyContext : true);
	}
	
	/**
	 * @inheritDoc
	 */
	public function set autodestroyContext (value:Boolean) : void {
		_autodestroyContext = new Flag(value);
	}
	
	/**
	 * @inheritDoc
	 */
	public function get autoremoveViewRoots () : Boolean {
		return (_autoremoveViewRoots) 
				? _autoremoveViewRoots.value 
				: ((_parents.length) ? _parents[0].autoremoveViewRoots : true);
	}

	/**
	 * @inheritDoc
	 */
	public function set autoremoveViewRoots (value:Boolean) : void {
		_autoremoveViewRoots = new Flag(value);
	}
	
	/**
	 * @inheritDoc
	 */
	public function get autoremoveComponents () : Boolean {
		return (_autoremoveComponents) 
				? _autoremoveComponents.value 
				: ((_parents.length) ? _parents[0].autoremoveComponents : true);
	}
	
	/**
	 * @inheritDoc
	 */
	public function set autoremoveComponents (value:Boolean) : void {
		_autoremoveComponents = new Flag(value);
	}
	
	/**
	 * @inheritDoc
	 */
	public function get autowireComponents () : Boolean {
		return (_autowireComponents) 
				? _autowireComponents.value 
				: ((_parents.length) ? _parents[0].autowireComponents : false);
	}
	
	/**
	 * @inheritDoc
	 */
	public function set autowireComponents (value:Boolean) : void {
		_autowireComponents = new Flag(value);
	}
	
	/**
	 * @inheritDoc
	 */
	public function get autowireFilter () : ViewAutowireFilter {
		return (_autowireFilter) 
				? _autowireFilter 
				: ((_parents.length) ? _parents[0].autowireFilter : new DefaultViewAutowireFilter(this));
	}
	
	/**
	 * @inheritDoc
	 */
	public function set autowireFilter (value:ViewAutowireFilter) : void {
		_autowireFilter = value;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addViewRootHandler (handler:Class, ...params) : void {
		_viewRootHandlers.push(new ServiceFactory(handler, params, ViewRootHandler));
	}
	
	/**
	 * @inheritDoc
	 */
	public function getViewRootHandlers (status:LookupStatus = null) : Array {
		var handlers:Array = _viewRootHandlers;
		var parentHandlers:Array;
		for each (var parent:ViewSettings in _parents) {
			if (!status) {
				status = new DefaultLookupStatus(this);
			}
			if (status.addInstance(parent)) {
				parentHandlers = parent.getViewRootHandlers(status);
				if (parentHandlers.length) {
					handlers = handlers.concat(parentHandlers);
				}
			}
			
		}
		return handlers;
	}
	
	
	private var viewLifecycles:Array = new Array();
	
	/**
	 * @inheritDoc
	 */
	public function addViewLifecycle (viewType:Class, lifecycle:Class, ...params : *) : void {
		viewLifecycles.push(new ViewLifecycleRegistration(viewType, lifecycle, params));
	}
	
	/**
	 * @inheritDoc
	 */
	public function newViewLifecycle (target:Object, status:LookupStatus = null) : ViewLifecycle {
		for each (var reg:ViewLifecycleRegistration in viewLifecycles) {
			if (reg.supports(target)) {
				return reg.newInstance();
			}
		}
		var lifecycle:ViewLifecycle;
		for each (var parent:ViewSettings in _parents) {
			if (!status) {
				status = new DefaultLookupStatus(this);
			}
			if (status.addInstance(parent)) {
				lifecycle = parent.newViewLifecycle(target, status);
				if (lifecycle) {
					return lifecycle;
				}
			}
			
		}
		return null;
	}
	
	
	private var _viewProcessor:DefaultService = new DefaultService(ViewProcessor);
	
	/**
	 * @inheritDoc
	 */
	public function get viewProcessor () : Service {
		return _viewProcessor;
	}
}
}

import org.spicefactory.parsley.core.bootstrap.impl.ServiceFactory;
import org.spicefactory.parsley.core.view.ViewLifecycle;

class ViewLifecycleRegistration {
	
	private var viewType:Class;
	private var serviceFactory:ServiceFactory;
	
	function ViewLifecycleRegistration (viewType:Class, lifecycle:Class, params:Array) {
		this.viewType = viewType;
		this.serviceFactory = new ServiceFactory(lifecycle, params, ViewLifecycle);
	}
	
	public function supports (target:Object) : Boolean {
		return (target is viewType);
	}
	
	public function newInstance () : ViewLifecycle {
		return serviceFactory.newInstance() as ViewLifecycle; 
	}
	
}
