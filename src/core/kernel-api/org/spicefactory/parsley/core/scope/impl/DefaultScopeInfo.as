/*
 * Copyright 2011 the original author or authors.
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

package org.spicefactory.parsley.core.scope.impl {

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.binding.BindingManager;
import org.spicefactory.parsley.core.binding.PersistenceManager;
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.Service;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.command.impl.DefaultCommandManager;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry;
import org.spicefactory.parsley.core.lifecycle.impl.DefaultLifecycleObserverRegistry;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeAware;
import org.spicefactory.parsley.core.scope.ScopeDefinition;
import org.spicefactory.parsley.core.scope.ScopeExtensions;
import org.spicefactory.parsley.core.scope.ScopeInfo;
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;


/**
 * Default implementation of the ScopeInfo interface.
 * 
 * @author Jens Halm
 */
public class DefaultScopeInfo implements ScopeInfo {
	
	
	private var domainManager:GlobalDomainManager;
	
	private var _name:String;
	private var _uuid:String;
	private var _inherited:Boolean;
	private var _rootContext:Context;
	
	private var _messageReceivers:DefaultMessageReceiverRegistry;
	private var _commandManager:DefaultCommandManager;
	private var _lifecycleObservers:LifecycleObserverRegistry;
	private var _lifecycleRegistry:DefaultMessageReceiverRegistry;
	private var _extensions:DefaultScopeExtensions;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param scopeDef the definition of the scope
	 * @param rootContext the root Context for this scope
	 * @param settings the message settings this scope should use
	 * @param extensions the extensions registered for this scope mapped by type (Class)
	 * @param domainManager the manager that keeps track of all ApplicationDomains currently used by one or more Contexts
	 */
	function DefaultScopeInfo (scopeDef:ScopeDefinition, info:BootstrapInfo) {
		_name = scopeDef.name;
		_uuid = scopeDef.uuid;
		_inherited = scopeDef.inherited;
		_rootContext = info.context;
		this.domainManager = info.globalState.domains;
		_messageReceivers = new DefaultMessageReceiverRegistry(domainManager);
		for each (var handler:MessageErrorHandler in info.messageSettings.getErrorHandlers()) {
			_messageReceivers.addErrorHandler(handler);
		}
		_commandManager = new DefaultCommandManager();
		_lifecycleRegistry = new DefaultMessageReceiverRegistry(domainManager);
		this._lifecycleObservers = new DefaultLifecycleObserverRegistry(_lifecycleRegistry);
		this._extensions = new DefaultScopeExtensions(info.scopeExtensions, initScopeExtension);
		bindingManagerConfig = info.bindingManager;
		persistenceManagerConfig = info.persistenceManager;
	}

	
	private function initScopeExtension (ext:Object) : void {
		if (ext is ScopeAware) {
			var scope:Scope = rootContext.scopeManager.getScope(name);
			ScopeAware(ext).init(scope);
		}
	}
	
	/**
	 * @inheritDoc
	 */	
	public function get name () : String {
		return _name;
	}
	
	/**
	 * @inheritDoc
	 */		
	public function get uuid () : String {
		return _uuid;
	}
	
	/**
	 * @inheritDoc
	 */	
	public function get inherited () : Boolean {
		return _inherited;
	}
	
	/**
	 * @inheritDoc
	 */	
	public function get rootContext () : Context {
		return _rootContext;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get messageReceivers () : MessageReceiverRegistry {
		return _messageReceivers;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getMessageReceiverCache (type:ClassInfo) : MessageReceiverCache {
		return _messageReceivers.getSelectionCache(type);
	}

	/**
	 * @inheritDoc
	 */
	public function get commandManager () : CommandManager {
		return _commandManager;
	}
	
	private var bindingManagerConfig: Service;
	private var _bindingManager: BindingManager;
	
	public function get bindingManager (): BindingManager {
		if (!_bindingManager) {
			_bindingManager = bindingManagerConfig.newInstance(initScopeExtension) as BindingManager;
		}
		return _bindingManager;
	}

	private var persistenceManagerConfig: Service;
	private var _persistenceManager: PersistenceManager;
	
	public function get persistenceManager (): PersistenceManager {
		if (!_persistenceManager) {
			_persistenceManager = persistenceManagerConfig.newInstance(initScopeExtension) as PersistenceManager;
		}
		return _persistenceManager;
	}
	
	/**
	 * @inheritDoc
	 */
	public function addActiveCommand (command:ObservableCommand) : void {
		_commandManager.addActiveCommand(command);
	}

	/**
	 * @inheritDoc
	 */
	public function get lifecycleObservers () : LifecycleObserverRegistry {
		return _lifecycleObservers;
	}
	
	/**
	 * @inheritDoc
	 */
	public function selectLifecycleObservers (type:ClassInfo, phaseKey:String, id:String = null) : Array {
		var allObservers:Array = [];
		var cache:MessageReceiverCache = _lifecycleRegistry.getSelectionCache(type);
		allObservers = concatLifecycleObservers(cache, phaseKey, allObservers);
		allObservers = concatLifecycleObservers(cache, phaseKey + ":" + id, allObservers);
		return allObservers;
	}
	
	private function concatLifecycleObservers (cache:MessageReceiverCache, selector:String, allObservers:Array) : Array {
		var observers:Array = cache.getReceivers(MessageReceiverKind.TARGET, selector);
		return (observers.length) ? allObservers.concat(observers) : allObservers;
	}

	/**
	 * @inheritDoc
	 */
	public function get extensions () : ScopeExtensions {
		return _extensions;
	}

	
}
}
