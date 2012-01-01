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

import flash.system.ApplicationDomain;
import org.spicefactory.lib.command.builder.CommandGroupBuilder;
import org.spicefactory.lib.command.builder.Commands;
import org.spicefactory.lib.logging.LogContext;
import org.spicefactory.lib.logging.Logger;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.binding.BindingManager;
import org.spicefactory.parsley.core.binding.PersistenceManager;
import org.spicefactory.parsley.core.command.CommandManager;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.events.ContextEvent;
import org.spicefactory.parsley.core.lifecycle.LifecycleObserverRegistry;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.MessageRouter;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessage;
import org.spicefactory.parsley.core.scope.Scope;
import org.spicefactory.parsley.core.scope.ScopeExtensions;
import org.spicefactory.parsley.core.scope.ScopeInfo;


/**
 * Default implementation of the Scope interface.
 * 
 * @author Jens Halm
 */
public class DefaultScope implements Scope {


	private static const log:Logger = LogContext.getLogger(DefaultScope);


	private var context:Context;
	private var deferredActions:CommandGroupBuilder;
	private var activated:Boolean = false;	
	
	private var info:ScopeInfo;
	private var messageRouter:MessageRouter;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param context the Context this scope instance is associated with
	 * @param info the shared info for this scope, holding all scope-wide state like registered message receivers
	 * @param router the message router to use for dispatching messages through this scope
	 * @param domain the ApplicationDomain to use for reflection
	 */
	function DefaultScope (context:Context, info:ScopeInfo, router:MessageRouter, domain:ApplicationDomain) {
		this.context = context;
		this.info = info;
		this.messageRouter = router;
		
		if (context.configured) {
			activated = true;
		}
		else {
			deferredActions = Commands.asSequence();
			context.addEventListener(ContextEvent.CONFIGURED, contextConfigured);
			context.addEventListener(ContextEvent.DESTROYED, contextDestroyed);
		}
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
		var cache:MessageReceiverCache = info.getMessageReceiverCache(type);
		if (!selector) {
			selector = info.getMessageReceiverCache(type).getSelectorValue(instance);
		}
		var message:Message = new DefaultMessage(instance, type, selector, context);
		if (cache.getReceivers(MessageReceiverKind.TARGET, message.selector).length == 0) {
			if (log.isDebugEnabled()) {
				log.debug("Discarding message '{0}' for scope '{1}': no matching receiver", instance, this);
			}
			return;
		}
		messageRouter.dispatchMessage(message, cache);
	}	
	
	/**
	 * @inheritDoc
	 */
	public function get name () : String {
		return info.name;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get uuid () : String {
		return info.uuid;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get inherited () : Boolean {
		return info.inherited;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get rootContext () : Context {
		return info.rootContext;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get messageReceivers () : MessageReceiverRegistry {
		return info.messageReceivers;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get commandManager () : CommandManager {
		return info.commandManager;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get bindingManager (): BindingManager {
		return info.bindingManager;
	}

	/**
	 * @inheritDoc
	 */
	public function get persistenceManager (): PersistenceManager {
		return info.persistenceManager;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get lifecycleObservers () : LifecycleObserverRegistry {
		return info.lifecycleObservers;
	}
	
	/**
	 * @inheritDoc
	 */
	public function get extensions () : ScopeExtensions {
		return info.extensions;
	}
	
	/**
	 * @private
	 */
	public function toString () : String {
		return "Scope " + name + " in " + rootContext;
	}


}
}

