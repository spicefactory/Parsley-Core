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

package org.spicefactory.parsley.core.bootstrap {
import org.spicefactory.parsley.core.bootstrap.impl.DefaultApplicationDomainProvider;
import org.spicefactory.parsley.core.bootstrap.impl.DefaultBootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.impl.DefaultBootstrapManager;
import org.spicefactory.parsley.core.context.impl.DefaultContext;
import org.spicefactory.parsley.core.lifecycle.impl.DefaultObjectLifecycleManager;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessageRouter;
import org.spicefactory.parsley.core.registry.impl.DefaultObjectDefinitionRegistry;
import org.spicefactory.parsley.core.scope.impl.DefaultScopeManager;
import org.spicefactory.parsley.core.view.handler.ContextLookupHandler;
import org.spicefactory.parsley.core.view.handler.ViewConfigurationHandler;
import org.spicefactory.parsley.core.view.impl.DefaultViewManager;
import org.spicefactory.parsley.core.view.processor.DefaultViewProcessor;

/**
 * Holds the instance that provides access to the global bootstrap configuration defaults 
 * for all settings and services that are not 
 * configured explicitly for a particular Context.
 * 
 * @author Jens Halm
 */
public class BootstrapDefaults {
	
	
	private static var defaults:BootstrapConfig;
	
	
	/**
	 * The default bootstrap configuration for all settings and services that are not 
 	 * configured explicitly for a particular Context.
	 */
	public static function get config () : BootstrapConfig {
		if (!defaults) {
			defaults = new DefaultBootstrapConfig();
			
			defaults.services.bootstrapManager.setImplementation(DefaultBootstrapManager);
			defaults.services.messageRouter.setImplementation(DefaultMessageRouter);
			defaults.services.context.setImplementation(DefaultContext);
			defaults.services.definitionRegistry.setImplementation(DefaultObjectDefinitionRegistry);
			defaults.services.lifecycleManager.setImplementation(DefaultObjectLifecycleManager);
			defaults.services.scopeManager.setImplementation(DefaultScopeManager);
			defaults.services.viewManager.setImplementation(DefaultViewManager);
			
			defaults.viewSettings.addViewRootHandler(ContextLookupHandler);
			defaults.viewSettings.addViewRootHandler(ViewConfigurationHandler);
			
			defaults.viewSettings.viewProcessor.setImplementation(DefaultViewProcessor);
			
			defaults.domainProvider = new DefaultApplicationDomainProvider();
		}
		return defaults;
	}
	
	
}
}
