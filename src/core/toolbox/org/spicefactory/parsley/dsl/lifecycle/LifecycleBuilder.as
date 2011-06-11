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
import org.spicefactory.parsley.core.registry.ObjectInstantiator;
import org.spicefactory.parsley.core.registry.ObjectProcessorFactory;
import org.spicefactory.parsley.dsl.core.ObjectDefinitionReplacer;
import org.spicefactory.parsley.processor.messaging.MessageReceiverFactory;

/**
 * Builder for configuration options that deal with object initialization and lifecycle management.
 * These hooks are primarily intended for custom tags that need to add functionality not provided
 * by the builtin configuration DSL.
 * 
 * @author Jens Halm
 */
public interface LifecycleBuilder {
	
	/**
	 * Sets the object responsible for creating instances from this definition.
	 * 
	 * @param type the object responsible for creating instances from this definition.
	 * @return this builder for method chaining
	 */
	function instantiator (value:ObjectInstantiator) : LifecycleBuilder;
	
	/**
	 * Sets this object as asynchronously initializing. Such an object will not be considered
	 * as fully initialized before it has thrown its complete event. Only has an effect for
	 * singleton definition.
	 * 
	 * @return a builder for asynchronous object initialization in case custom event types need to be specified
	 */
	function asyncInit () : AsyncInitBuilder;
	
	/**
	 * Sets a custom object processor factory. The factory creates a new objects processor
	 * for each instance produced by the definition created by this builder. The processor
	 * in turn will be invoked for the target object's key lifecycle events.
	 * 
	 * @param factory a custom object processor factory to be used for the target definition
	 * @return this builder for method chaining
	 */
	function processorFactory (factory:ObjectProcessorFactory) : LifecycleBuilder;
	
	/**
	 * Sets a custom message receiver factory. Such a factory is useful if a target object
	 * needs to use a custom way of receiving a message not provided by the builtin implementations
	 * of the various message receiver interfaces. The factory will be invoked for each
	 * 
	 * @param factory a custom message receiver factory to be used for the target definition
	 * @param scope the scope the custom receiver will listen to, the default is 'global'
	 * @return this builder for method chaining
	 */
	function messageReceiverFactory (factory:MessageReceiverFactory, scope:String = null) : LifecycleBuilder;
	
	/**
	 * Sets the instance that will replace (or wrap) the final object definition.
	 * This is an advanced feature. From all the builtin tags only the Factory tag
	 * uses this hook.
	 * 
	 * @param replacer the instance that will replace the final object definition
	 * @return this builder for method chaining
	 */
	function definitionReplacer (replacer:ObjectDefinitionReplacer) : LifecycleBuilder;
	
	
}
}
