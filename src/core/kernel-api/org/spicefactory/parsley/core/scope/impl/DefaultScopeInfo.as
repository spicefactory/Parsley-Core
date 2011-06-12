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
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry;
import org.spicefactory.parsley.core.lifecycle.impl.DefaultLifecycleObserverRegistry;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.MessageSettings;
import org.spicefactory.parsley.core.messaging.command.Command;
import org.spicefactory.parsley.core.messaging.command.CommandManager;
import org.spicefactory.parsley.core.messaging.command.impl.DefaultCommandManager;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.scope.InitializingExtension;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeDefinition;
import org.spicefactory.parsley.core.scope.ScopeExtensions;
import org.spicefactory.parsley.core.scope.ScopeInfo;
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;

import flash.utils.Dictionary;

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
	function DefaultScopeInfo (scopeDef:ScopeDefinition, rootContext:Context, settings:MessageSettings,
			extensions:Dictionary, domainManager:GlobalDomainManager) {
		_name = scopeDef.name;
		_uuid = scopeDef.uuid;
		_inherited = scopeDef.inherited;
		_rootContext = rootContext;
		this.domainManager = domainManager;
		_messageReceivers = new DefaultMessageReceiverRegistry(domainManager);
		for each (var handler:MessageErrorHandler in settings.getErrorHandlers()) {
			_messageReceivers.addErrorHandler(handler);
		}
		_commandManager = new DefaultCommandManager();
		_lifecycleRegistry = new DefaultMessageReceiverRegistry(domainManager);
		this._lifecycleObservers = new DefaultLifecycleObserverRegistry(_lifecycleRegistry);
		this._extensions = new DefaultScopeExtensions(extensions, initScopeExtension);
	}

	
	private function initScopeExtension (ext:Object) : void {
		if (ext is InitializingExtension) {
			var scope:Scope = rootContext.scopeManager.getScope(name);
			InitializingExtension(ext).init(scope);
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
	
	/**
	 * @inheritDoc
	 */
	public function addActiveCommand (command:Command) : void {
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
	public function getLifecycleObserverCache (type:ClassInfo) : MessageReceiverCache {
		return _lifecycleRegistry.getSelectionCache(type);
	}

	/**
	 * @inheritDoc
	 */
	public function get extensions () : ScopeExtensions {
		return _extensions;
	}
	
	
}
}
