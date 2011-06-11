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

package org.spicefactory.parsley.dsl.lifecycle.impl {
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionContext;
import org.spicefactory.parsley.processor.lifecycle.ObserveMethodProcessorFactory;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.impl.ObjectDefinitionBuilderPart;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.dsl.lifecycle.ObserveMethodBuilder;

/**
 * Default implementation of the ObserveMethodBuilder interface.
 * 
 * @author Jens Halm
 */
public class DefaultObserveMethodBuilder implements ObserveMethodBuilder, ObjectDefinitionBuilderPart {


	private var context:ObjectDefinitionContext;
	private var method:String;

	private var _scope:String;
	private var _phase:ObjectLifecycle = ObjectLifecycle.POST_INIT;
	private var _objectId:String;

	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the context for the definition to build
	 * @param method the name of the observer method
	 */
	function DefaultObserveMethodBuilder (context:ObjectDefinitionContext, method:String) {
		this.context = context;
		this.method = method;
	}

	
	/**
	 * @inheritDoc
	 */
	public function scope (name:String) : ObserveMethodBuilder {
		_scope = name;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function phase (value:ObjectLifecycle) : ObserveMethodBuilder {
		_phase = value;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function objectId (id:String) : ObserveMethodBuilder {
		_objectId = id;
		return this;
	}
	
	/**
	 * @inheritDoc
	 */
	public function apply (target:ObjectDefinition) : void {
		target.addProcessorFactory(new ObserveMethodProcessorFactory(target, method, _phase, _objectId, context.config.context, _scope));
	}
	
	
}
}
