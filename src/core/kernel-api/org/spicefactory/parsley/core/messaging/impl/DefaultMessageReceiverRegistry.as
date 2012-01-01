/*
 * Copyright 2008-2010 the original author or authors.
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

package org.spicefactory.parsley.core.messaging.impl {
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;
import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.parsley.core.messaging.MessageReceiverKind;
import org.spicefactory.parsley.core.messaging.MessageReceiverRegistry;
import org.spicefactory.parsley.core.messaging.receiver.CommandObserver;
import org.spicefactory.parsley.core.messaging.receiver.MessageErrorHandler;
import org.spicefactory.parsley.core.messaging.receiver.MessageReceiver;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.state.manager.GlobalDomainManager;


/**
 * Default implementation of the MessageReceiverRegistry interface.
 * 
 * @author Jens Halm
 */
public class DefaultMessageReceiverRegistry implements MessageReceiverRegistry {
	
	
	
	private var receivers:Dictionary = new Dictionary();
	
	private var selectionCache:Dictionary = new Dictionary();
	
	private var domainManager:GlobalDomainManager;
	
	
	/**
	 * Creates a new instance.
	 * 
	 * @param domainManager the manager that keeps track of all ApplicationDomains currently used by one or more Contexts
	 */
	function DefaultMessageReceiverRegistry (domainManager:GlobalDomainManager) {
		this.domainManager = domainManager;
	}

	/**
	 * Returns the selection of receivers that match the specified message type.
	 * 
	 * @param messageType the message type to match against
	 * @return the selection of receivers that match the specified message type
	 */
	public function getSelectionCache (messageType:ClassInfo) : DefaultMessageReceiverCache {
		var receiverSelection:DefaultMessageReceiverCache =
				selectionCache[messageType.getClass()] as DefaultMessageReceiverCache;
		if (receiverSelection == null) {
			var collections:Array = new Array();
			for each (var collection:MessageReceiverCollection in receivers) {
				if (messageType.isType(collection.messageType)) {
					collections.push(collection);
				}
			}
			receiverSelection = new DefaultMessageReceiverCache(messageType, collections);
			selectionCache[messageType.getClass()] = receiverSelection;
			domainManager.addPurgeHandler(messageType.applicationDomain, clearDomainCache, messageType.getClass());
		}
		return receiverSelection;
	}
	
	private function clearDomainCache (domain:ApplicationDomain, type:Class) : void {
		var receiverSelection:DefaultMessageReceiverCache = selectionCache[type] as DefaultMessageReceiverCache;
		receiverSelection.release();
		delete selectionCache[type];
	}
	
	
	private function addReceiver (kind:MessageReceiverKind, receiver:MessageReceiver) : void {
		var collection:MessageReceiverCollection = receivers[receiver.type] as MessageReceiverCollection;
		if (collection == null) {
			collection = new MessageReceiverCollection(receiver.type);
			receivers[receiver.type] = collection; 
			for each (var cache:DefaultMessageReceiverCache in selectionCache) {
				cache.checkNewCollection(collection);
			}
		}
		collection.addReceiver(kind, receiver);
	}
	
	private function removeReceiver (kind:MessageReceiverKind, receiver:MessageReceiver) : void {
		var collection:MessageReceiverCollection = receivers[receiver.type] as MessageReceiverCollection;
		if (collection == null) {
			return;
		}
		collection.removeReceiver(kind, receiver);
	}
	
	
	/**
	 * @inheritDoc
	 */
	public function addTarget (target:MessageTarget) : void {
		addReceiver(MessageReceiverKind.TARGET, target);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeTarget (target:MessageTarget) : void {
		removeReceiver(MessageReceiverKind.TARGET, target);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addErrorHandler (errorHandler:MessageErrorHandler) : void {
		addReceiver(MessageReceiverKind.ERROR_HANDLER, errorHandler);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeErrorHandler (errorHandler:MessageErrorHandler) : void {
		removeReceiver(MessageReceiverKind.ERROR_HANDLER, errorHandler);
	}
	
	/**
	 * @inheritDoc
	 */
	public function addCommandObserver (observer:CommandObserver) : void {
		addReceiver(observer.kind, observer);
	}
	
	/**
	 * @inheritDoc
	 */
	public function removeCommandObserver (observer:CommandObserver) : void {
		removeReceiver(observer.kind, observer);
	}
	
	
}
}

