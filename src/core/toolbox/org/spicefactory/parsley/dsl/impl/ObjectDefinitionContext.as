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

package org.spicefactory.parsley.dsl.impl {
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.config.Configuration;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilder;
import org.spicefactory.parsley.dsl.core.ObjectDefinitionReplacer;

/**
 * Provides the context for a single object definition builder.
 * This is primarily used internally and not considered part of the public API.
 * 
 * @author Jens Halm
 */
public interface ObjectDefinitionContext {
	
	
	/**
	 * The parent definition represents the first definition processed by this context.
	 * In case of subsequent processing this definition should be used as the parent of new
	 * definitions. Before the first definition has been processed, this property is null.
	 */
	function get parent () : ObjectDefinition;
	
	/**
	 * The type of the class to be configured.
	 */
	function get targetType () : ClassInfo;
	
	/**
	 * The configuration of the associated registry.
	 */
	function get config () : Configuration;
	
	/**
	 * The assemblers to use to assemble the decorators for the target definition.
	 */
	function get assemblers () : Array;

	/**
	 * Adds a part to the builder that gets executed when building the final definition.
	 * 
	 * @param part the part to add to the builder
	 */
	function addBuilderPart (part:ObjectDefinitionBuilderPart) : void;
	
	/**
	 * Adds a function to execute when building the final definition.
	 * 
	 * @param fc the function to execute when building the final definition
	 * @param additionalArgs additional arguments to pass to the function
	 */
	function addBuilderFunction (fc:Function, ...additionalArgs) : void;

	/**
	 * Sets the instance that will replace (or wrap) the final object definition.
	 * This is an advanced feature. From all the builtin tags only the Factory tag
	 * uses this hook.
	 * 
	 * @param replacer the instance that will replace the final object definition
	 */	
	function setDefinitionReplacer (replacer:ObjectDefinitionReplacer) : void;

	/**
	 * Processes the specified definition, applying all builder parts added to this
	 * context, all decorators assembled by this context and the specified additional decorators 
	 * and finally invoking the definition replacer (if specified). If no replacer was specified
	 * this method usually should return the definition that was passed in.
	 * 
	 * @param target the target definition to process
	 * @param additionalDecorators decorators to add to the ones extracted by the standard assemblers
	 * @param builder the builder of the specified definition
	 * @return the final definition to use
	 */
	function processDefinition (target:ObjectDefinition, additionalDecorators:Array, builder:ObjectDefinitionBuilder) : ObjectDefinition;
	
	
	
}
}
