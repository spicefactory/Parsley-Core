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

package org.spicefactory.parsley.config {
import org.spicefactory.parsley.dsl.ObjectDefinitionBuilderFactory;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;

import flash.system.ApplicationDomain;

/**
 * Represents the configuration for a single Context to be used by the core configuration DSL.
 * 
 * @author Jens Halm
 */
public interface Configuration {
	
	
	/**
	 * The ApplicationDomain to use for reflection.
	 */
	function get domain () : ApplicationDomain;
	
	/**
	 * The registry holding object definitions for the Context.
	 */
	function get registry () : ObjectDefinitionRegistry;
	
	/**
	 * The target Context this configuration is used for.
	 */
	function get context () : Context;
	
	/**
	 * The factory to create new object definition builders from.
	 */
	function get builders () : ObjectDefinitionBuilderFactory;
	
	
}
}
