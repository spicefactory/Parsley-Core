/*
 * Copyright 2009/2010 the original author or authors.
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

package org.spicefactory.parsley.core.scope {
import org.spicefactory.parsley.core.context.LookupStatus;
import org.spicefactory.parsley.core.bootstrap.Service;

import flash.utils.Dictionary;

/**
 * A registry for scope-wide extensions.
 * Usually used for registering manager-type objects that may be used by custom configuration tags.
 * 
 * @author Jens Halm
 */
public interface ScopeExtensionRegistry {
	
	
	/**
	 * Returns the service registration for the specified type.
	 * If no such service has been registered yet, a new registration will be created.
	 * The returned registration can be used to specify the implementation class or just decorators for existing
	 * registrations. The type passed to this method is usually the service interface of the scope extension, 
	 * so that alternative implementations can be registered. But this is not a requirement, the specified type
	 * may be the same as the implementation.
	 * 
	 * <p>In a standard use case this method will get used like this:</p>
	 * <code><pre>BootstrapDefaults.config.scopeExtensions.forType(MyService).setImplementation(MyServiceImpl);</pre></code>
	 * <p>The above would mean that the service would be registered globally. Alternatively the <code>BootstrapInfo</code>
	 * for a particular Context may be used to register an extension just for one Context (and its children, if any).</p>
	 * 
	 * @param type the type of service, usually the service interface
	 * @return the service configuration which can be modified 
	 */
	function forType (type:Class) : Service;
	
	/**
	 * Returns all service registrations that were created in this registry.
	 * The Dictionary will map the type (usually the service interface) to <code>Service</code>
	 * instances holding the full configuration for the service.
	 * 
	 * @param status optional paramater to avoid duplicate lookups, for internal use only 
	 * @return all service registrations that were created in this registry
	 */
	function getAll (status:LookupStatus = null) : Dictionary;
	
	
}
}
