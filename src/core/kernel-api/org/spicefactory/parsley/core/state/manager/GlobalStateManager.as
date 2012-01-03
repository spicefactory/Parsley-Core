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

package org.spicefactory.parsley.core.state.manager {

/**
 * The central entry point for access to all global state managers.
 * 
 * <p>This manager is usually only exposed to the IOC kernel services and can be accessed through a <code>BootstrapInfo</code>
 * instance.</p>
 * 
 * @author Jens Halm
 */
public interface GlobalStateManager {
	
	
	/**
	 * The manager that keeps track of all managed objects of all the currently active Context instances.
	 */
	function get objects () : GlobalObjectManager;
	
	/**
	 * The manager that keeps track of the currently active Context instances.
	 */
	function get contexts () : GlobalContextManager;
	
	/**
	 * The manager that keeps track of all scopes of all the currently active Context instances.
	 */
	function get scopes () : GlobalScopeManager;
	
	/**
	 * The manager that keeps track of all ApplicationDomains of all the currently active Context instances.
	 */
	function get domains () : GlobalDomainManager;
	
	
}
}
