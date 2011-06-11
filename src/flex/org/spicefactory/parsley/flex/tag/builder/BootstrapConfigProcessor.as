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

package org.spicefactory.parsley.flex.tag.builder {
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;

/**
 * Interface to be implemented by child tags of the ContextBuilder MXML tag.
 * Child tags can be used for adding configuration artifacts, declaring custom scopes 
 * or initializing extensions.
 * 
 * @author Jens Halm
 */
public interface BootstrapConfigProcessor extends ContextBuilderChildTag {
	
	
	/**
	 * Processes the specified configuration instance, adding configuration artifacts, declaring custom scopes 
	 * or initializing extensions.
	 * <p>To initialize a global extension like a custom configuration tag or a replacement or decorator for one of 
	 * the IOC Kernel services, the corresponding hooks like <code>BootstrapDefaults.config</code> 
	 * should be used and the config parameter can simply be ignored.</p>
	 * 
	 * @param config the configuration that will be used to create the Context
	 */
	function processConfig (config:BootstrapConfig) : void;
	
	
}
}
