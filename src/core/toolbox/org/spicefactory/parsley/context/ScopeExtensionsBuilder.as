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

package org.spicefactory.parsley.context {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;

/**
 * Builder for registering scope extensions.
 * 
 * @author Jens Halm
 */
public class ScopeExtensionsBuilder implements SetupPart {
	
	
	private var setup:ContextBuilderSetup;
	
	private var builder:ServiceBuilder;
	private var type:Class;
	
	
	/**
	 * @private
	 */
	function ScopeExtensionsBuilder (setup:ContextBuilderSetup) {
		this.setup = setup;
	}

	
	/**
	 * Specifies the implementation of a scope extension. A new instance
	 * of the extension will be created for each scope that gets created.
	 * 
	 * @param type the type of the extension
	 * @return the builder for specifying the implementation or decorators for the scope extension
	 */	
	public function forType (type:Class) : ServiceBuilder {
		this.type = type;
		builder = new ServiceBuilder(setup);
		return builder;
	}
	
	/**
	 * @private
	 */
	public function apply (config:BootstrapConfig) : void {
		if (builder != null) {
			builder.configureService(config.scopeExtensions.forType(type));
		}
	}
	
	
}
}

