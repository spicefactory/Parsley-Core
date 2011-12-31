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

package org.spicefactory.parsley.lifecycle {

import org.spicefactory.parsley.core.builder.ObjectDefinitionBuilder;
import org.spicefactory.parsley.core.processor.InitPhase;
import org.spicefactory.parsley.core.processor.Phase;
import org.spicefactory.parsley.lifecycle.processor.ObserveMethodProcessor;

/**
 * API for defining methods that observe the lifecycle of a particular type of managed object.
 * 
 * @author Jens Halm
 */
public class Observe {


	private var method:String;

	private var _scope:String;
	private var _phase:Phase;
	private var _objectId:String;

	
	/**
	 * @private
	 */
	function Observe (method:String) {
		this.method = method;
		this._phase = InitPhase.postInit(int.MIN_VALUE);
	}

	
	/**
	 * Sets the name of the scope to observe.
	 * The default is <code>ScopeName.GLOBAL</code>.
	 * Only matching objects created in the target scope will be considered 
	 * for invocation of the observer method.
	 * 
	 * @param name the name of the scope to observe
	 * @return this builder for method chaining
	 */
	public function scope (name:String) : Observe {
		_scope = name;
		return this;
	}
	
	/**
	 * Sets the lifecycle phase this observer is interested in.
	 * The default is <code>ObjectLifecycle.POST_INIT</code>.
	 * 
	 * @param value the lifecycle phase this observer is interested in
	 * @return this builder for method chaining
	 */
	public function phase (value:Phase) : Observe {
		_phase = value;
		return this;
	}
	
	/**
	 * Sets the (optional) id of the object the observer is interested in.
	 * When omitted all objects with a matching type deduced from the method
	 * parameter will be observed.
	 * 
	 * @param id the id of the object the observer is interested in
	 * @return this builder for method chaining
	 */
	public function objectId (id:String) : Observe {
		_objectId = id;
		return this;
	}
	
	/**
	 * Applies this configuration to the specified definition builder.
	 * 
	 * @param builder the builder to apply this configuration to
	 */
	public function apply (builder: ObjectDefinitionBuilder): void {
		builder.method(method).process(new ObserveMethodProcessor(_phase, _objectId, _scope));
	}
	
	
	/**	
	 * Creates a new builder for an observer method.
	 * 
	 * @param method the method that receives the observed instance(s)
	 * @return a new builder for an observer method 
	 */
	public static function forMethod (method:String) : Observe {
		return new Observe(method);
	}
	
	
}
}
