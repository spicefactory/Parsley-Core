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
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;

/**
 * Responsible for determining the ApplicationDomain based on a provided view instance.
 * This is a pluggable strategy that will be used in the Context bootstrap sequence in 
 * case that no ApplicationDomain has been specified explicitly (which is quite common).
 * 
 * @author Jens Halm
 */
public interface ApplicationDomainProvider {
	
	
	/**
	 * Determines and returns the ApplicationDomain the specified DisplayObject belongs to.
	 * If the domain cannot be specified, this method should return null. Errors should preferrably
	 * only be logged but not rethrown.
	 * 
	 * @param view the view that acts as the first view root for a new Context
	 * @param domainManager the manager that can be used to fetch existing domain instances to keep the reflection cache small
	 * @return the ApplicationDomain the new Context should use for reflection
	 */
	function getDomainForView (view:DisplayObject, domainManager:GlobalDomainManager) : ApplicationDomain;
	
	
}
}
