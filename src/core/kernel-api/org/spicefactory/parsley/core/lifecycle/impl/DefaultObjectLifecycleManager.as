/*
 * Copyright 2008-2009 the original author or authors.
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

package org.spicefactory.parsley.core.lifecycle.impl {
import org.spicefactory.lib.util.ArrayUtil;
import org.spicefactory.parsley.core.bootstrap.BootstrapInfo;
import org.spicefactory.parsley.core.bootstrap.InitializingService;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.lifecycle.ManagedObject;
import org.spicefactory.parsley.core.lifecycle.ManagedObjectHandler;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycle;
import org.spicefactory.parsley.core.lifecycle.ObjectLifecycleManager;
import org.spicefactory.parsley.core.messaging.Message;
import org.spicefactory.parsley.core.messaging.MessageReceiverCache;
import org.spicefactory.parsley.core.messaging.MessageRouter;
import org.spicefactory.parsley.core.messaging.impl.DefaultMessage;
import org.spicefactory.parsley.core.messaging.impl.MessageReceiverKind;
import org.spicefactory.parsley.core.registry.ObjectDefinition;
import org.spicefactory.parsley.core.scope.ScopeInfoRegistry;
import org.spicefactory.parsley.core.scope.ScopeInfo;
import org.spicefactory.parsley.core.state.manager.GlobalObjectManager;

import flash.system.ApplicationDomain;

/**
 * Default implementation of the ObjectLifecycleManager interface.
 * 
 * @author Jens Halm
 */
public class DefaultObjectLifecycleManager implements ObjectLifecycleManager, InitializingService {
	
	
	private var handlers:Array = new Array();
	private var destroyed:Boolean;

	private var domain:ApplicationDomain;
	private var scopes:ScopeInfoRegistry;
	private var messageRouter:MessageRouter;
	
	/**
	 * @private
	 */
	internal var globalObjectManager:GlobalObjectManager;


	/**
	 * Creates a new instance.
	 */
	function DefaultObjectLifecycleManager () {
		
	}

	/**
	 * @inheritDoc
	 */
	public function init (info:BootstrapInfo) : void {
		this.domain = info.domain;
		this.scopes = info.scopeInfoRegistry;
		this.messageRouter = info.messageRouter;
		this.globalObjectManager = info.globalState.objects;
	}

	/**
	 * @inheritDoc
	 */
	public function createHandler (definition:ObjectDefinition, context:Context) : ManagedObjectHandler {
		var handler:ManagedObjectHandler = new DefaultManagedObjectHandler(definition, context, this);
		handlers.push(handler);
		return handler;
	}

	/**
	 * @private
	 */	
	internal function processObservers (target:ManagedObject, event:ObjectLifecycle) : void {
		/*
		 * TODO - 3.0 - observers should be an ObjectProcessor
		 */
		var typeMessage:Message = new DefaultMessage(target.instance, target.definition.type, event.key);
		var idMessage:Message = (target.definition.id != null) ?
				new DefaultMessage(target.instance, target.definition.type, event.key + ":" + target.definition.id) : null;
		for each (var info:ScopeInfo in scopes.activeScopes) {
			dispatchLifecycleMessage(info, typeMessage, idMessage);
		}
	}
	
	private function dispatchLifecycleMessage (info:ScopeInfo, typeMessage:Message, idMessage:Message = null) : void {
		var cache:MessageReceiverCache = info.getLifecycleObserverCache(typeMessage.type);
		if (cache.getReceivers(typeMessage, MessageReceiverKind.TARGET).length > 0) {
			messageRouter.dispatchMessage(typeMessage, cache);
		}
		if (idMessage && cache.getReceivers(idMessage, MessageReceiverKind.TARGET).length > 0) {
			messageRouter.dispatchMessage(idMessage, cache);
		}
	}	
	
	/**
	 * @private
	 */	
	internal function removeHandler (handler:ManagedObjectHandler) : void {
		if (destroyed) return;
		ArrayUtil.remove(handlers, handler);
	}
	
	/**
	 * @inheritDoc
	 */
	public function destroyAll () : void {
		destroyed = true;
		try {
			for each (var handler:ManagedObjectHandler in handlers) {
				handler.destroyObject();
			}
		}
		finally {
			handlers = new Array();
		}
	}
	
	
}

}