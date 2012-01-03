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

package org.spicefactory.parsley.core.state.manager.impl {

import org.spicefactory.parsley.core.state.manager.GlobalContextManager;
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;
import org.spicefactory.parsley.core.state.manager.GlobalObjectManager;
import org.spicefactory.parsley.core.state.manager.GlobalScopeManager;
import org.spicefactory.parsley.core.state.manager.GlobalStateManager;

/**
 * Default implementation of the GlobalStateManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultGlobalStateManager implements GlobalStateManager {
	
	
	private var objectManager:GlobalObjectManager = new DefaultGlobalObjectManager();
	
	/**
	 * @inheritDoc
	 */
	public function get objects () : GlobalObjectManager {
		return objectManager;
	}
	
	
	private var domainManager:DefaultGlobalDomainManager = new DefaultGlobalDomainManager();
	
	/**
	 * @inheritDoc
	 */
	public function get domains () : GlobalDomainManager {
		return domainManager;
	}
	
	
	private var contextManager:GlobalContextManager;
	
	/**
	 * @inheritDoc
	 */
	public function get contexts () : GlobalContextManager {
		if (!contextManager) {
			contextManager = new DefaultGlobalContextManager(domainManager);
		}
		return contextManager;
	}
	
	
	private var scopeManager:GlobalScopeManager = new DefaultGlobalScopeManager();
	
	/**
	 * @inheritDoc
	 */
	public function get scopes () : GlobalScopeManager {
		return scopeManager;
	}
	
	
}
}
