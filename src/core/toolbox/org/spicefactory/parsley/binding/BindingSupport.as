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
 
package org.spicefactory.parsley.binding {
import org.spicefactory.lib.reflect.Metadata;
import org.spicefactory.parsley.binding.decorator.PublishDecorator;
import org.spicefactory.parsley.binding.decorator.PublishSubscribeDecorator;
import org.spicefactory.parsley.binding.decorator.SubscribeDecorator;
import org.spicefactory.parsley.binding.impl.DefaultBindingManager;
import org.spicefactory.parsley.binding.impl.LocalPersistenceManager;
import org.spicefactory.parsley.core.bootstrap.BootstrapDefaults;
import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.scope.ScopeExtensionRegistry;


/**
 * Provides a static method to initalize the decoupled binding facility.
 * Can be used as a child tag of a &lt;ContextBuilder&gt; tag in MXML alternatively.
 * The core Parsley distribution automatically includes this extension, thus
 * there is usually no need to explicitly initialize it in applications.
 * 
 * @author Jens Halm
 */
public class BindingSupport {
	
	
	private static var initialized:Boolean = false;
	

	/**
	 * Initializes the support for decoupled bindings.
	 * Installs the Publish, Subscribe and PublishSubscribe tags for metadata, MXML and XML.
	 * Must be invoked before a <code>ContextBuilder</code> is used for the first time.
	 * 
	 * <p>The core Parsley distribution automatically includes this extension, thus
 	 * there is usually no need to explicitly initialize it in applications.</p>
  	 */
	public static function initialize () : void {
		if (initialized) return;
		
		Metadata.registerMetadataClass(SubscribeDecorator);
		Metadata.registerMetadataClass(PublishDecorator);
		Metadata.registerMetadataClass(PublishSubscribeDecorator);
		
		var scopeExtensions:ScopeExtensionRegistry = BootstrapDefaults.config.scopeExtensions;
		
		scopeExtensions.forType(BindingManager).setImplementation(DefaultBindingManager);
		var service:Service = scopeExtensions.forType(PersistenceManager);
		if (!service.factory) {
			service.setImplementation(LocalPersistenceManager);
		}
		
		initialized = true;
	}
}
}
