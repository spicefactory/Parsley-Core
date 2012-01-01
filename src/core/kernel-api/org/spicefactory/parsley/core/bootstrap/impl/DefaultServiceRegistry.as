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

package org.spicefactory.parsley.core.bootstrap.impl {

import org.spicefactory.parsley.core.binding.BindingManager;
import org.spicefactory.parsley.core.binding.PersistenceManager;
import org.spicefactory.parsley.core.bootstrap.BootstrapManager;
import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.bootstrap.ServiceRegistry;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycleManager;
import org.spicefactory.parsley.core.messaging.MessageRouter;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.scope.ScopeManager;
import org.spicefactory.parsley.core.view.ViewManager;

/**
 * Default implementation of the ServiceRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultServiceRegistry implements ServiceRegistry {
	
	
	/**
	 * Adds a parent registry to be used to pull additional decorators and the default implementation from.
	 * 
	 * @param parent a parent registry
	 */
	public function addParent (parent:ServiceRegistry) : void {
		_bootstrapManager.addParent(parent.bootstrapManager);
		_messageRouter.addParent(parent.messageRouter);
		_context.addParent(parent.context);
		_definitionRegistry.addParent(parent.definitionRegistry);
		_lifecycleManager.addParent(parent.lifecycleManager);
		_scopeManager.addParent(parent.scopeManager);
		_viewManager.addParent(parent.viewManager);
		_bindingManager.addParent(parent.bindingManager);
		_persistenceManager.addParent(parent.persistenceManager);
	}

	
	private var _bootstrapManager:DefaultService = new DefaultService(BootstrapManager); 
	
	/**
	 * @inheritDoc
	 */
	public function get bootstrapManager () : Service {
		return _bootstrapManager;
	}
	
	
	private var _messageRouter:DefaultService = new DefaultService(MessageRouter); 
	
	/**
	 * @inheritDoc
	 */
	public function get messageRouter () : Service {
		return _messageRouter;
	}
	
	
	private var _context:DefaultService = new DefaultService(Context); 
	
	/**
	 * @inheritDoc
	 */
	public function get context () : Service {
		return _context;
	}
	
	
	private var _definitionRegistry:DefaultService = new DefaultService(ObjectDefinitionRegistry); 
	
	/**
	 * @inheritDoc
	 */
	public function get definitionRegistry () : Service {
		return _definitionRegistry;
	}
	
	
	private var _lifecycleManager:DefaultService = new DefaultService(ObjectLifecycleManager); 
	
	/**
	 * @inheritDoc
	 */
	public function get lifecycleManager () : Service {
		return _lifecycleManager;
	}
	
	
	private var _scopeManager:DefaultService = new DefaultService(ScopeManager); 
	
	/**
	 * @inheritDoc
	 */
	public function get scopeManager () : Service {
		return _scopeManager;
	}
	
	
	private var _viewManager:DefaultService = new DefaultService(ViewManager); 
	
	/**
	 * @inheritDoc
	 */
	public function get viewManager () : Service {
		return _viewManager;
	}


	private var _bindingManager:DefaultService = new DefaultService(BindingManager); 

	/**
	 * @inheritDoc
	 */
	public function get bindingManager (): Service {
		return _bindingManager;
	}


	private var _persistenceManager:DefaultService = new DefaultService(PersistenceManager);
	
	/**
	 * @inheritDoc
	 */
	public function get persistenceManager (): Service {
		return _persistenceManager;
	}
	
	
}
}
