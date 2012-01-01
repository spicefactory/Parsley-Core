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

import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.bootstrap.BootstrapConfig;
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.InitializingService;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycleManager;
import org.spicefactory.parsley.core.messaging.MessageRouter;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.registry.ConfigurationProperties;
import org.spicefactory.parsley.core.registry.ObjectDefinitionRegistry;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeInfoRegistry;
import org.spicefactory.parsley.core.scope.ScopeManager;
import org.spicefactory.parsley.core.state.manager.GlobalStateManager;
import org.spicefactory.parsley.core.view.ViewManager;
import org.spicefactory.parsley.core.view.ViewSettings;

import flash.display.DisplayObject;
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;

/**
 * Default implementation of the BootstrapConfig interface.
 * 
 * @author Jens Halm
 */
public class DefaultBootstrapInfo implements BootstrapInfo {
	
	
	private var config:BootstrapConfig;
	private var deferredInit:Array = new Array();
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param config the configuration instance to use for the Context getting built
	 * @param scopes the scopes to be created by the Context getting built
	 * @param scopeExtensions the extensions to be created by each scope mapped by type (Class)
	 * @param globalState the global internal state of the container
	 */
	function DefaultBootstrapInfo (config:BootstrapConfig, scopes:ScopeInfoRegistry, scopeExtensions:Dictionary, 
			globalState:GlobalStateManager, decoratorAssemblers:Array) {
		this.config = config;
		this._scopeInfoRegistry = scopes;
		this._scopeExtensions = scopeExtensions;
		this._globalState = globalState;
		this._decoratorAssemblers = decoratorAssemblers;
	}

	
	/**
	 * @inheritDoc
	 */
	public function get description () : String {
		return config.description;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get viewRoot () : DisplayObject {
		return config.viewRoot;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get domain () : ApplicationDomain {
		return config.domain;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get parents () : Array {
		return config.parents;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get properties () : ConfigurationProperties {
		return config.properties;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get viewSettings () : ViewSettings {
		return config.viewSettings;
	}
	
	private var _globalState:GlobalStateManager;
	
	/**
	 * @inheritDoc
	 */
	public function get globalState () : GlobalStateManager {
		return _globalState;
	}
	
	private var _decoratorAssemblers:Array;
	
	/**
	 * @inheritDoc
	 */
	public function get decoratorAssemblers (): Array {
		return _decoratorAssemblers;
	}

	/**
	 * @inheritDoc
	 */
	public function get messageSettings () : MessageSettings {
		return config.messageSettings;
	}


	private var _context:Context;
	
	/**
	 * @inheritDoc
	 */
	public function get context () : Context {
		if (_context == null) {
			_context = config.services.context.newInstance(initContext) as Context;
			for each (var service:InitializingService in deferredInit) {
				service.init(this);
			}
			deferredInit = new Array();
			if (config.viewRoot != null) {
				_context.viewManager.addViewRoot(config.viewRoot);
			}
		}
		return _context;
	}
	
	
	private var _registry:ObjectDefinitionRegistry;
	
	/**
	 * @inheritDoc
	 */
	public function get registry () : ObjectDefinitionRegistry {
		if (_registry == null) {
			_registry = config.services.definitionRegistry.newInstance(initService) as ObjectDefinitionRegistry;
		}
		return _registry;
	}


	private var _lifecycleManager:ObjectLifecycleManager;
	
	/**
	 * @inheritDoc
	 */
	public function get lifecycleManager () : ObjectLifecycleManager {
		if (_lifecycleManager == null) {
			_lifecycleManager = config.services.lifecycleManager.newInstance(initService) as ObjectLifecycleManager;
		}
		return _lifecycleManager;
	}


	private var _viewManager:ViewManager;
	
	/**
	 * @inheritDoc
	 */
	public function get viewManager () : ViewManager {
		if (_viewManager == null) {
			_viewManager = config.services.viewManager.newInstance(initService) as ViewManager;
		}
		return _viewManager;
	}


	private var _scopeManager:ScopeManager;
	
	/**
	 * @inheritDoc
	 */
	public function get scopeManager () : ScopeManager {
		if (_scopeManager == null) {
			_scopeManager = config.services.scopeManager.newInstance(initService) as ScopeManager;
			registerScopes();
		}
		return _scopeManager;
	}
	
	
	private var _messageRouter:MessageRouter;
	
	/**
	 * @inheritDoc
	 */
	public function get messageRouter () : MessageRouter {
		if (_messageRouter == null) {
			_messageRouter = config.services.messageRouter.newInstance(initService) as MessageRouter;
		}
		return _messageRouter;
	}
	
	private function initContext (context:Context) : void {
		if (context is InitializingService) {
			deferredInit.push(context);
		}
	}
	
	private function initService (service:Object) : void {
		if (service is InitializingService) {
			InitializingService(service).init(this);
		}
	}
	
	
	private var _scopeInfoRegistry:ScopeInfoRegistry;
	
	/**
	 * @inheritDoc
	 */
	public function get scopeInfoRegistry () : ScopeInfoRegistry {
		return _scopeInfoRegistry;
	}
	
	private function registerScopes () : void {
		for each (var scope:Scope in _scopeManager.getAllScopes()) {
			if (scope.rootContext == context) {
				_globalState.scopes.addScope(scope);
			}
		}
	}
	
	
	private var _scopeExtensions:Dictionary;
	
	/**
	 * @inheritDoc
	 */
	public function get scopeExtensions () : Dictionary {
		return _scopeExtensions;
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function get bindingManager (): Service {
		return config.services.bindingManager;
	}

	/**
	 * @inheritDoc
	 */
	public function get persistenceManager (): Service {
		return config.services.persistenceManager;
	}


}
}
