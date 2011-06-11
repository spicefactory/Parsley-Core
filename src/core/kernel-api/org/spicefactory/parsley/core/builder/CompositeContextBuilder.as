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

package org.spicefactory.parsley.core.builder {
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.factory.FactoryRegistry;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor;

[Deprecated(replacement="BootstrapManager")]
/**
 * @author Jens Halm
 */
public interface CompositeContextBuilder {
	
	[Deprecated(replacement="addProcessor")]
	function addBuilder (builder:ObjectDefinitionBuilder) : void;
	
	function addProcessor (processor:org.spicefactory.parsley.core.bootstrap.ConfigurationProcessor) : void;
	
	function addScope (name:String, inherited:Boolean = true, uuid:String = null) : void;
	
	function get factories () : FactoryRegistry;
	
	/**
	 * Builds the registry and Context for this builder without
	 * invoking the ConfigurationProcessors.
	 * After this method has been called, changes to the
	 * factories or adding further scopes does not have any
	 * effect on this builder.
	 * But the associated registry can still be modified and 
	 * further ConfigurationProcessors can also be added to this builder
	 * until the <code>build</code> method is called.
	 *
	 * @return the registry used by this builder or null if this builder does not use a registry
	 */
	function prepareRegistry () : ObjectDefinitionRegistry; 
	 
	/**
	 * Builds the Context, using all definition builders that were added with the addBuilder method.
	 * The returned Context instance may not be fully initialized if it requires asynchronous operations.
	 * You can check its state with its <code>configured</code> and <code>initialized</code> properties.
	 * 
	 * @return a new Context instance, possibly not fully initialized yet
	 */
	function build () : Context;
	
}
}
