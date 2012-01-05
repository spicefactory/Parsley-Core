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

package org.spicefactory.parsley.core.view.impl {
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.util.Flag;
import org.spicefactory.parsley.core.registry.DynamicObjectDefinition;
import org.spicefactory.parsley.core.view.ViewConfiguration;
import org.spicefactory.parsley.core.view.ViewLifecycle;
import org.spicefactory.parsley.core.view.ViewProcessor;

import flash.display.DisplayObject;

/**
 * Default implementation of the ViewConfiguration interface.
 * 
 * @author Jens Halm
 */
public class DefaultViewConfiguration implements ViewConfiguration {
	
	
	/**
	 * Creates a new instance. If no target is specified the view itself is used as the target.
	 * 
	 * @param view the view that controls the lifecycle of the target
	 * @param target the target to get processed by the Context
	 * @param configId the configuration id to use to fetch matching definitions from the Context
	 */
	function DefaultViewConfiguration (view:DisplayObject, target:Object = null, configId:String = null) {
		_view = view;
		_target = target;
		_configId = configId;
	}
	
	
	private var _target:Object;
	
	/**
	 * @inheritDoc
	 */
	public function get target () : Object {
		return (_target) ? _target : _view; 
	}

	
	private var _view:DisplayObject;
	
	/**
	 * @inheritDoc
	 */
	public function get view () : DisplayObject {
		return _view;
	}


	private var _processor:ViewProcessor;
	
	/**
	 * @inheritDoc
	 */
	public function get processor () : ViewProcessor {
		return _processor;
	}
	
	public function set processor (value : ViewProcessor) : void {
		if (_processor) throw IllegalStateError("ViewProcessor has already been specified");
		_processor = value;
	}

	
	private var _lifecycle:ViewLifecycle;

	/**
	 * @inheritDoc
	 */
	public function get lifecycle () : ViewLifecycle {
		return _lifecycle;
	}
	
	public function set lifecycle (value : ViewLifecycle) : void {
		if (_lifecycle) throw IllegalStateError("Lifecycle has already been specified");
		_lifecycle = value;
	}
	
	
	private var _autoremove:Flag;
	
	/**
	 * @inheritDoc
	 */
	public function get autoremove () : Flag {
		return _autoremove;
	}

	public function set autoremove (value:Flag) : void {
		_autoremove = value;
	}
	
	
	private var _definition:DynamicObjectDefinition;

	/**
	 * @inheritDoc
	 */
	public function get definition () : DynamicObjectDefinition {
		return _definition;
	}
	
	public function set definition (value:DynamicObjectDefinition) : void {
		if (_definition) throw IllegalStateError("ObjectDefinition has already been specified");
		_definition = value;
	}

	
	private var _configId: String;
	
	/**
	 * @inheritDoc
	 */
	public function get configId () : String {
		return (_configId != null) ? _configId 
			: (target is DisplayObject) 
			? DisplayObject(target).name : null;
	}
	
	
	private var _reuse:Flag;
	
	/**
	 * @inheritDoc
	 */
	public function get reuse () : Flag {
		return _reuse;
	}
	
	public function set reuse (value:Flag) : void {
		_reuse = value;
	}
	
	
}
}
