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

package org.spicefactory.parsley.runtime {

import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
import org.spicefactory.parsley.core.bootstrap.BootstrapManager;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.runtime.processor.RuntimeConfigurationProcessor;

import flash.display.DisplayObject;

/**
 * Static entry point methods for building a Context from existing instances.
 * The <code>build</code> method will very likely be rarely used as it is usually
 * not recommended to determine all context objects at runtime.
 * But the <code>merge</code> method may be useful for adding individual existing
 * instances to otherwise static configuration artifacts.
 * This class may also be useful in UnitTests.
 * 
 * <p>These static entry points only allow to add existing instances without specifying
 * an id or any further configuration, so only metadata will be processed.
 * For more options and more fine-grained control the <code>RuntimeConfigurationProcessor</code>
 * should be used directly and then added to a <code>CompositeContextBuilder</code>.</p>
 * 
 * <p>For details see 
 * <a href="http://www.spicefactory.org/parsley/docs/2.4/manual?page=config&amp;section=runtime">3.5 Runtime Configuration</a>
 * in the Parsley Manual.</p>
 * 
 * @author Jens Halm
 */
public class RuntimeContextBuilder {
	
	
	/**
	 * Builds a Context that only contains the specified existing instances.
	 * The returned Context instance may not be fully initialized if it requires asynchronous operations.
	 * You can check its state with its <code>configured</code> and <code>initialized</code> properties.
	 * 
	 * @param instances the instances to include in the Context
	 * @param viewRoot the initial view root for dynamically wiring view objects
	 * @return a new Context instance, possibly not fully initialized yet
	 */
	public static function build (instances:Array, viewRoot:DisplayObject = null) : Context {
		var manager:BootstrapManager = BootstrapDefaults.config.services.bootstrapManager.newInstance() as BootstrapManager;
		manager.config.viewRoot = viewRoot;
		manager.config.addProcessor(new RuntimeConfigurationProcessor(instances));
		return manager.createProcessor().process();
	}
	
	
}
}

