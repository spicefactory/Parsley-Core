/*
 * Copyright 2009 the original author or authors.
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

import org.spicefactory.lib.command.builder.CommandGroupBuilder;
import org.spicefactory.lib.command.builder.Commands;
import org.spicefactory.lib.errors.IllegalArgumentError;
import org.spicefactory.lib.errors.IllegalStateError;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.InitializingService;
import org.spicefactory.parsley.core.command.ObservableCommand;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageRouter;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessage;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeDefinition;
import org.spicefactory.parsley.core.scope.ScopeInfo;
import org.spicefactory.parsley.core.scope.ScopeInfoRegistry;
import org.spicefactory.parsley.core.scope.ScopeManager;

import flash.utils.Dictionary;


/**
 * Default implementation of the ScopeManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultScopeManager implements ScopeManager, InitializingService {
	
	
	private static const log:Logger = LogContext.getLogger(DefaultScope);
	
	
	private var context:Context;
	private var deferredActions:CommandGroupBuilder;
	private var activated:Boolean = false;	
	
	private var scopes:Dictionary = new Dictionary();
	private var defaultReceiverScope:String;
	
	private var messageRouter:MessageRouter;
	private var scopeInfoRegistry:ScopeInfoRegistry;
	
	
	/**
	 * @inheritDoc
	 */
	public function init (info:BootstrapInfo) : void {
		this.context = info.context;
		this.messageRouter = info.messageRouter;
		this.scopeInfoRegistry = info.scopeInfoRegistry;
		initScopes(info);
		defaultReceiverScope = info.messageSettings.defaultReceiverScope;

		if (context.configured) {
			activated = true;
		}
		else {
			deferredActions = Commands.asSequence();
			context.addEventListener(ContextEvent.CONFIGURED, contextConfigured);
			context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		}
	}
	
	/**
	 * Creates all scopes managed by this instance.
	 * The given BootstrapInfo instance provides information about all scopes
	 * inherited by parent Contexts and all new scope definitions added for this Context.
	 * The default implementation manages all these scopes and throws an error in case
	 * of finding more than one scope with the same name.
	 * This method can be overridden by custom ScopeManagers to allow fine-grained
	 * control which scopes should be inherited and/or created.
	 * 
	 * @param info a BootstrapInfo instance providing information about all scopes
	 * inherited by parent Contexts and all new scope definitions added for this Context
	 */
	protected function initScopes (info:BootstrapInfo) : void {
		for each (var scopeInfo:ScopeInfo in scopeInfoRegistry.parentScopes) {
			addScope(scopeInfo, info);
		}
		for each (var scopeDef:ScopeDefinition in scopeInfoRegistry.newScopes) {
			var newScope:ScopeInfo = new DefaultScopeInfo(scopeDef, info.context, info.messageSettings, info.scopeExtensions, info.globalState.domains);
			addScope(newScope, info);
		}
	}
	
	/**
	 * Adds the specified scope to the active scopes of this manager.
	 * 
	 * @param scopeInfo the scope to add to this manager
	 * @param info the environment of the Context building process
	 */
	protected function addScope (scopeInfo:ScopeInfo, info:BootstrapInfo) : void {
		if (scopes[scopeInfo.name]) {
			throw new IllegalStateError("Duplicate scope with name: " + scopeInfo.name);
		}
		scopeInfoRegistry.addActiveScope(scopeInfo);
		var scope:Scope = new DefaultScope(info.context, scopeInfo, messageRouter, info.domain);
		scopes[scope.name] = scope;
	}

	private function contextConfigured (event:ContextEvent) : void {
		removeListeners();
		activated = true;
		deferredActions.execute();
		deferredActions = null;
	}
	
	private function contextDestroyed (event:ContextEvent) : void {
		removeListeners();
	}
	
	private function removeListeners () : void {
		context.removeEventListener(ContextEvent.CONFIGURED, contextConfigured);
		context.removeEventListener(ContextEvent.DESTROYED, contextDestroyed);
	}

	/**
	 * @inheritDoc
	 */
	public function hasScope (name:String) : Boolean {
		return (scopes[name] != undefined);
	}
	
	/**
	 * @inheritDoc
	 */
	public function getScope (name:String = null) : Scope {
		if (!name) {
			name = defaultReceiverScope;
		}
		if (!hasScope(name)) {
			throw new IllegalArgumentError("This router does not contain a scope with name " + name);
		}
		return scopes[name] as Scope;
	}
	
	/**
	 * @inheritDoc
	 */
	public function getAllScopes () : Array {
		var scopes:Array = new Array();
		for each (var scope:Scope in this.scopes) {
			scopes.push(scope);
		}
		return scopes;
	}
	
	/**
	 * @inheritDoc
	 */
	public function dispatchMessage (message:Object, selector:* = undefined) : void {
		if (!activated) {
			deferredActions.add(Commands.delegate(doDispatchMessage, message, selector));
		}
		else {
			doDispatchMessage(message, selector);
		}
	}
	
	private function doDispatchMessage (instance:Object, selector:*) : void {
		var type:ClassInfo = ClassInfo.forInstance(instance, context.domain);
		var caches:Array = new Array();
		for each (var scope:ScopeInfo in scopeInfoRegistry.activeScopes) {
			caches.push(scope.getMessageReceiverCache(type));
		}
		var cache:MessageReceiverCache = new MergedMessageReceiverCache(caches);
		if (!selector) {
			selector = cache.getSelectorValue(instance);
		}
		var message:Message = new DefaultMessage(instance, type, selector, context);
		if (cache.getReceivers(MessageReceiverKind.TARGET, selector).length == 0) {
			if (log.isDebugEnabled()) {
				log.debug("Discarding message '{0}': no matching receiver in any scope", instance);
			}
			return;
		}
		messageRouter.dispatchMessage(message, cache);
	}
	
	/**
	 * @inheritDoc
	 */
	public function observeCommand (command:ObservableCommand) : void {
		if (!activated) {
			deferredActions.add(Commands.delegate(doObserveCommand, command));
		}
		else {
			doObserveCommand(command);
		}
	}
	
	private function doObserveCommand (command:ObservableCommand) : void {
		var typeCaches:Array = new Array();
		var triggerCaches:Array = new Array();
		for each (var scope:ScopeInfo in scopeInfoRegistry.activeScopes) {
			if (command.trigger) {
				triggerCaches.push(scope.getMessageReceiverCache(command.trigger.type));
			}
			typeCaches.push(scope.getMessageReceiverCache(command.type));
			scope.addActiveCommand(command);
		}
		var typeCache:MessageReceiverCache = new MergedMessageReceiverCache(typeCaches);
		var triggerCache:MessageReceiverCache = new MergedMessageReceiverCache(triggerCaches);
		command.observe(function (command:ObservableCommand) : void {
			handleCommand(command, typeCache, triggerCache);
		});
		handleCommand(command, typeCache, triggerCache); // TODO - prevent suspension in CommandStatus.EXECUTE
	}
	
	private function handleCommand (command:ObservableCommand, 
			typeCache:MessageReceiverCache, triggerCache:MessageReceiverCache) : void {
		if (!hasReceivers(command, typeCache, triggerCache)) {
			if (log.isDebugEnabled()) {
				log.debug("Discarding command status {0} for message '{1}': no matching observer", 
						command.status, command.trigger.instance);
			}
			return;
		}
		messageRouter.observeCommand(command, typeCache, triggerCache);
	}
	
	private function hasReceivers (command:ObservableCommand, 
			typeCache:MessageReceiverCache, triggerCache:MessageReceiverCache) : Boolean {
		if (command.trigger 
				&& triggerCache.getReceivers(MessageReceiverKind.forCommandStatus(command.status, true), command.trigger.selector).length > 0) {
			return true;
		}
		return (typeCache.getReceivers(MessageReceiverKind.forCommandStatus(command.status, false), command.id).length > 0);
	}
	
}
}

import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;

class MergedMessageReceiverCache implements MessageReceiverCache {

	private var caches:Array;
	
	function MergedMessageReceiverCache (caches:Array) {
		this.caches = caches;
	}

	public function getReceivers (kind:MessageReceiverKind, selector:* = undefined) : Array {
		var receivers:Array = new Array();
		for each (var cache:MessageReceiverCache in caches) {
			var merge:Array = cache.getReceivers(kind, selector);
			if (merge.length > 0) {
				receivers = (receivers.length > 0) ? receivers.concat(merge) : merge;
			}
		}
		return receivers;
	}
	
	public function getSelectorValue (message:Object) : * {
		return (caches.length) ? MessageReceiverCache(caches[0]).getSelectorValue(message) : undefined;
	}
	
	
}

