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

package org.spicefactory.parsley.dsl.lifecycle {
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;

/**
 * Builder for an object lifecycle observer method.
 * 
 * @author Jens Halm
 */
public interface ObserveMethodBuilder {
	
	
	/**
	 * Sets the name of the scope to observe.
	 * The default is <code>ScopeName.GLOBAL</code>.
	 * Only matching objects created in the target scope will be considered 
	 * for invocation of the observer method.
	 * 
	 * @param name the name of the scope to observe
	 * @return this builder for method chaining
	 */
	function scope (name:String) : ObserveMethodBuilder;

	/**
	 * Sets the lifecycle phase this observer is interested in.
	 * The default is <code>ObjectLifecycle.POST_INIT</code>.
	 * 
	 * @param value the lifecycle phase this observer is interested in
	 * @return this builder for method chaining
	 */
	function phase (value:ObjectLifecycle) : ObserveMethodBuilder;
	
	/**
	 * Sets the (optional) id of the object the observer is interested in.
	 * When omitted all objects with a matching type deduced from the method
	 * parameter will be observed.
	 * 
	 * @param id the id of the object the observer is interested in
	 * @return this builder for method chaining
	 */
	function objectId (id:String) : ObserveMethodBuilder;
	
	
}
}
